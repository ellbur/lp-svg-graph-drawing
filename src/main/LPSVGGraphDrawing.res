
module Graph = LPSVGGraphDrawing_Graph
module RenderedGraph = LPSVGGraphDrawing_RenderedGraph
module TextNode = LPSVGGraphDrawing_TextNode
module StringMetrics = LPSVGGraphDrawing_StringMetrics

module Document = Webapi.Dom.Document
module Element = Webapi.Dom.Element

type textSizer = LPSVGGraphDrawing_StringMetrics.textSizer
type stringMetrics = LPSVGGraphDrawing_StringMetrics.stringMetrics
let textElemMetrics = LPSVGGraphDrawing_StringMetrics.textElemMetrics

let {setAttribute} = module(Webapi.Dom.Element)
let fts = Belt.Float.toString

let removeAllChildren = el => {
  let rec step = () => {
    switch el->Element.lastChild {
      | None => ()
      | Some(child) => {
        el->Element.removeChild(~child)->ignore
        step()
      }
    }
  }
  step()
}

let minFloat = (x: float, y: float) => if (x < y) { x } else { y }
let maxFloat = (x: float, y: float) => if (x > y) { x } else { y }
let arrayMin = ar => ar->Array.reduce(Pervasives.infinity, minFloat)
let arrayMax = ar => ar->Array.reduce(Pervasives.neg_infinity, maxFloat)

let renderGraph = (~document: Document.t, ~svg: Element.t, ~graph: Graph.graph, ~textSizer: textSizer = NativeBBox) => {
  let {text, defs, marker, path, g} = module(LPSVGGraphDrawing_SVGUtils)
  let {orientation} = graph.graphMetrics
  
  let nodeMap = graph.nodes->Array.map(n => (n.id, n))->Dict.fromArray

  svg->Element.appendChild(~child=document->defs(~children=[
    document->marker(
      ~id="arrow",
      ~viewBox="0 0 10 10",
      ~refX="0",
      ~refY="5",
      ~markerUnits="userSpaceOnUse",
      ~markerWidth="10",
      ~markerHeight="10",
      ~orient="auto",
      ~children=[
        document->path(
          ~d="M 0 0 L 10 5 L 0 10 z",
          ~fill="#999",
          ~class="edge-marker-end",
          ()
        )
      ],
      ()
    )
  ]))
  
  module EdgeRendering = {
    type t = {
      pathElem: Element.t,
      sinkLabelElem: Element.t,
      metrics: Graph.edgeMetrics,
    }
  }

  module EdgePlacement = {
    type t = {
      pathPoints: array<(float, float)>,
      sinkLabelX: float,
      sinkLabelY: float
    }
  }
  
  let edgeRenderings = Js.Dict.empty()
  
  {
    let {edges} = graph
    edges->Belt.Array.forEach(({edgeID, sinkLabel, edgeMetrics}) => {
      let edgePath = document->path(
        ~fill="none",
        ~strokeWidth=edgeMetrics.edgeStrokeWidth,
        ~markerEnd="url(#arrow)",
        ~class="edge",
        ~stroke="#999",
        ()
      )
        
      let edgeSinkBaseline = switch orientation {
        | FlowingUp => "hanging"
        | FlowingDown => "auto"
      }
      let edgeSinkText = document->text(
        ~textAnchor="start",
        ~dominantBaseline=edgeSinkBaseline,
        ~fontSize=edgeMetrics.edgeSinkLabelFontSize,
        ~fontFamily=edgeMetrics.edgeSinkLabelFontFamily,
        ~class="edge-sink-text",
        ~textContent=sinkLabel,
        ()
      )
      
      svg->Element.appendChild(~child=edgePath)
      svg->Element.appendChild(~child=edgeSinkText)
      
      edgeRenderings->Js.Dict.set(edgeID, {
        EdgeRendering.pathElem: edgePath,
        EdgeRendering.sinkLabelElem: edgeSinkText,
        metrics: edgeMetrics
      })
    })
  }
  
  module F = Graph
  module T = LPLayout.Graph
  
  let lpGraph: T.graph = {
    nodes: graph.nodes->Belt.Array.map(node => {
      let {id, display} = node
      
      let {width, height} = display
      
      ({
        id: id,
        width,
        height,
        centerX: display.relativeCX,
        centerY: display.relativeCY
      }: T.node)
    }),
    
    edges: graph.edges->Belt.Array.map(edge => {
      let {edgeID, source, sink, sourceAttachment, sinkAttachment} = edge

      let sinkNode = nodeMap->Dict.get(sink)->Option.getExn
      let sourceNode = nodeMap->Dict.get(source)->Option.getUnsafe
      let {display: {sinkAttachments, relativeCX: sinkCX, massWidth: sinkMassWidth}} = sinkNode
      let {display: {sourceAttachments, relativeCX: sourceCX, massWidth: sourceMassWidth}} = sourceNode

      let {relativeX: sinkRelativeX} = sinkAttachments->Dict.get(sinkAttachment)->Option.getExn
      let {relativeX: sourceRelativeX} = sourceAttachments->Dict.get(sourceAttachment)->Option.getExn
      
      let sinkPos = (sinkRelativeX -. sinkCX) /. sinkMassWidth

      ({
        edgeID,
        source,
        sink,
        sinkPos
      }: T.edge)
    })
  }
  
  let layout = LPLayout.doLayout(lpGraph, {xSpacing: graph.graphMetrics.xSpacing, ySpacing: graph.graphMetrics.ySpacing, orientation: graph.graphMetrics.orientation})
  let {nodeCenterXs, nodeCenterYs, edgeExtraNodes} = layout
  
  graph.nodes->Belt.Array.forEach(node => {
    let {id, display} = node
    
    let cx = nodeCenterXs->Js.Dict.unsafeGet(id)
    let cy = nodeCenterYs->Js.Dict.unsafeGet(id)
    
    let {g: nodeG, relativeCX: nodeRelativeCX, relativeCY: nodeRelativeCY} = display
    
    let cxT = cx -. nodeRelativeCX
    let cyT = cy -. nodeRelativeCY
    
    let transform = `translate(${fts(cxT)}, ${fts(cyT)})`
    
    nodeG->Element.setAttribute("transform", transform)
  })

  let edgePlacements = Js.Dict.empty()
  
  graph.edges->Belt.Array.forEach(edge => {
    let {edgeID, source, sink, sourceAttachment, sinkAttachment, edgeMetrics} = edge
    let edgeRendering = edgeRenderings->Js.Dict.unsafeGet(edgeID)
    let {pathElem, sinkLabelElem} = edgeRendering
    
    let sinkNode = nodeMap->Dict.get(sink)->Option.getExn
    let sourceNode = nodeMap->Dict.get(source)->Option.getUnsafe
    let {display: {sinkAttachments, relativeCX: sinkRelativeCX, relativeCY: sinkRelativeCY}} = sinkNode
    let {display: {sourceAttachments, relativeCX: sourceRelativeCX, relativeCY: sourceRelativeCY}} = sourceNode

    let {relativeX: sinkRelativeX, relativeY: sinkRelativeY} = sinkAttachments->Dict.get(sinkAttachment)->Option.getExn
    let {relativeX: sourceRelativeX, relativeY: sourceRelativeY} = sourceAttachments->Dict.get(sourceAttachment)->Option.getExn

    let cx1 = nodeCenterXs->Js.Dict.unsafeGet(source)
    let cy1 = nodeCenterYs->Js.Dict.unsafeGet(source)
    
    let cx2 = nodeCenterXs->Js.Dict.unsafeGet(sink)
    let cy2 = nodeCenterYs->Js.Dict.unsafeGet(sink)
    
    let xStart = cx1 -. sourceRelativeCX +. sourceRelativeX
    let yStart = cy1 -. sourceRelativeCY +. sourceRelativeY

    let xEnd = cx2 -. sinkRelativeCX +. sinkRelativeX
    let yEnd = cy2 -. sinkRelativeCY +. sinkRelativeY
    
    let pointsToTravelThrough = [(xStart, yStart)]
    edgeExtraNodes->Js.Dict.get(edgeID)->Belt.Option.forEach(extraNodes => {
      extraNodes->Belt.Array.forEach(extraNode => {
        let px = nodeCenterXs->Js.Dict.unsafeGet(extraNode)
        let py = nodeCenterYs->Js.Dict.unsafeGet(extraNode)
        
        pointsToTravelThrough->Belt.Array.push((px, py))
      })
    })
    pointsToTravelThrough->Belt.Array.push((xEnd, yEnd))
    
    let workingD = ref(`M ${fts(xStart)} ${fts(yStart)}`)
    {
      let len = pointsToTravelThrough->Js.Array2.length
      let rec step = i => {
        if i < len {
          let p1 = pointsToTravelThrough[i-1]->Option.getExn
          let p2 = pointsToTravelThrough[i]->Option.getExn
          
          let (x1, y1) = p1
          let (x2, y2) = p2
          
          let bx1 = x1
          let by1 = (1.0 -. edgeMetrics.edgeRectangularness)*.y1 +. edgeMetrics.edgeRectangularness*.y2

          let bx2 = x2
          let by2 = edgeMetrics.edgeRectangularness*.y1 +. (1.0 -. edgeMetrics.edgeRectangularness)*.y2
          
          workingD.contents = workingD.contents ++ ` C ${fts(bx1)} ${fts(by1)} ${fts(bx2)} ${fts(by2)} ${fts(x2)} ${fts(y2)}`
          
          step(i + 1)
        }
      }
      step(1)
    }
    
    pathElem->setAttribute("d", workingD.contents)
    
    let sinkLabelX = xEnd +. edgeMetrics.edgeSinkLabelXOffset
    let sinkLabelY = switch orientation {
      | FlowingUp => yEnd -. 10.0 +. edgeMetrics.edgeSinkLabelYOffset
      | FlowingDown => yEnd +. 10.0 -. edgeMetrics.edgeSinkLabelYOffset
    }

    sinkLabelElem->setAttribute("x", fts(sinkLabelX))
    sinkLabelElem->setAttribute("y", fts(sinkLabelY))

    edgePlacements->Js.Dict.set(edgeID, {
      EdgePlacement.pathPoints: pointsToTravelThrough,
      sinkLabelX,
      sinkLabelY
    })
  })
  
  let renderedNodes = Js.Dict.empty()
  graph.nodes->Js.Array2.forEach(({id: nodeID, display}) => {
    let x = (layout.nodeCenterXs->Js.Dict.unsafeGet(nodeID))
    let y = (layout.nodeCenterYs->Js.Dict.unsafeGet(nodeID))
    let gx = x -. (display.relativeCX)
    let gy = y -. (display.relativeCY)
    renderedNodes->Js.Dict.set(nodeID, ({
      gx,
      gy,
      g: display.g,
      nodeBBox: {
        minX: gx,
        maxX: gx +. display.width,
        minY: gy,
        maxY: gy +. display.height,
      }
    }: RenderedGraph.renderedNode))
  })
  
  let renderedEdges = Js.Dict.empty()
  edgeRenderings->Js.Dict.entries->Js.Array2.forEach(((edgeID, rendering: EdgeRendering.t)) => {
    let placement: EdgePlacement.t = edgePlacements->Js.Dict.unsafeGet(edgeID)
    let pathXs = placement.pathPoints->Array.map(((x, _)) => x)
    let pathYs = placement.pathPoints->Array.map(((_, y)) => y)

    let pathMinX = pathXs->arrayMin
    let pathMaxX = pathXs->arrayMax
    let pathMinY = pathYs->arrayMin
    let pathMaxY = pathYs->arrayMax

    let {stringWidth: labelWidth, stringHeight: labelHeight} = textElemMetrics(textSizer, rendering.sinkLabelElem, ~fontSize=rendering.metrics.edgeSinkLabelFontSize, ~fontFamily=rendering.metrics.edgeSinkLabelFontFamily)

    let labelMinX = placement.sinkLabelX
    let labelMinY = placement.sinkLabelY
    let labelMaxX = placement.sinkLabelX +. labelWidth
    let labelMaxY = placement.sinkLabelY +. labelHeight

    let minX = minFloat(pathMinX, labelMinX)
    let minY = minFloat(pathMinY, labelMinY)
    let maxX = maxFloat(pathMaxX, labelMaxX)
    let maxY = maxFloat(pathMaxY, labelMaxY)

    renderedEdges->Js.Dict.set(edgeID, ({
      path: rendering.pathElem,
      sinkLabel: rendering.sinkLabelElem,
      edgeBBox: {
        minX,
        maxX,
        minY,
        maxY,
      }
    }: RenderedGraph.renderedEdge))
  })

  let nodeMaxX = renderedNodes->Js.Dict.values->Array.map((r: RenderedGraph.renderedNode) => {
    r.nodeBBox.maxX
  })->arrayMax

  let nodeMaxY = renderedNodes->Js.Dict.values->Array.map((r: RenderedGraph.renderedNode) => {
    r.nodeBBox.maxY
  })->arrayMax

  let edgeMaxX = renderedEdges->Js.Dict.values->Array.map(e => e.edgeBBox.maxX)->arrayMax
  let edgeMaxY = renderedEdges->Js.Dict.values->Array.map(e => e.edgeBBox.maxY)->arrayMax

  let totalMaxX = maxFloat(nodeMaxX, edgeMaxX)
  let totalMaxY = maxFloat(nodeMaxY, edgeMaxY)

  let totalWidth = totalMaxX +. (graph.graphMetrics.xSpacing /. 2.0)
  let totalHeight = totalMaxY +. (graph.graphMetrics.ySpacing /. 2.0)

  svg->setAttribute("width", fts(totalWidth))
  svg->setAttribute("height", fts(totalHeight))
  
  ({
    nodes: renderedNodes,
    edges: renderedEdges,
    layout: layout,
  }: RenderedGraph.t)
}

