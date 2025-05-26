
module Graph = LPSVGGraphDrawing_Graph
module RenderedGraph = LPSVGGraphDrawing_RenderedGraph

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
  let {rect, text, defs, marker, path, g} = module(LPSVGGraphDrawing_SVGUtils)
  let {orientation} = graph.graphMetrics
  
  removeAllChildren(svg)
  
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
  
  let mainG = document->g(~children=[])
  svg->Element.appendChild(~child=mainG)
  
  module NodeRendering = {
    type t = {
      nodeG: Element.t,
      nodeRelativeCX: float,
      nodeRelativeCY: float,
      nodeBoxWidth: float,
      nodeBoxHeight: float,
      nodeMarginLeft: float,
      nodeMarginRight: float,
      nodeMarginTop: float,
      nodeMarginBottom: float,
      nodeWidth: float,
      nodeHeight: float,
      nodeFlatWidth: float,
      border: Element.t,
      label: Element.t,
      lowerLeftLabel: option<Element.t>,
      upperLeftLabel: option<Element.t>,
      upperRightLabel: option<Element.t>,
      lowerRightLabel: option<Element.t>,
    }
  }
  
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
      
      mainG->Element.appendChild(~child=edgePath)
      mainG->Element.appendChild(~child=edgeSinkText)
      
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
        marginLeft: nodeMarginLeft,
        marginRight: nodeMarginRight,
        marginTop: nodeMarginTop,
        marginBottom: nodeMarginBottom,
      }: T.node)
    }),
    
    edges: graph.edges->Belt.Array.map(edge => {
      let {edgeID, source, sink, sinkPos} = edge
      
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
    let {id } = node
    
    let cx = nodeCenterXs->Js.Dict.unsafeGet(id)
    let cy = nodeCenterYs->Js.Dict.unsafeGet(id)
    
    let nodeRendering = nodeRenderings->Js.Dict.unsafeGet(id)
    let {nodeG, nodeRelativeCX, nodeRelativeCY} = nodeRendering
    
    let cxT = cx -. nodeRelativeCX
    let cyT = cy -. nodeRelativeCY
    
    let transform = `translate(${fts(cxT)}, ${fts(cyT)})`
    
    nodeG->Element.setAttribute("transform", transform)
  })

  let edgePlacements = Js.Dict.empty()
  
  graph.edges->Belt.Array.forEach(edge => {
    let {edgeID, source, sink, sinkPos, edgeMetrics} = edge
    let edgeRendering = edgeRenderings->Js.Dict.unsafeGet(edgeID)
    let {pathElem, sinkLabelElem} = edgeRendering
    let sinkRendering = nodeRenderings->Js.Dict.unsafeGet(sink)
    let sourceRendering = nodeRenderings->Js.Dict.unsafeGet(source)
    
    let cx1 = nodeCenterXs->Js.Dict.unsafeGet(source)
    let cy1 = nodeCenterYs->Js.Dict.unsafeGet(source)
    
    let cx2 = nodeCenterXs->Js.Dict.unsafeGet(sink)
    let cy2 = nodeCenterYs->Js.Dict.unsafeGet(sink)
    
    let boxHeight1 = sourceRendering.NodeRendering.nodeBoxHeight
    let boxFlatWidth2 = sinkRendering.NodeRendering.nodeFlatWidth
    let boxHeight2 = sinkRendering.NodeRendering.nodeBoxHeight
    
    let xStart = cx1
    let yStart = switch orientation {
      | FlowingUp => cy1 -. boxHeight1/.2.0
      | FlowingDown => cy1 +. boxHeight1/.2.0
    }
    
    let xEnd = cx2 +. sinkPos*.boxFlatWidth2*.0.9/.2.0
    let yEnd = switch orientation {
      | FlowingUp => cy2 +. boxHeight2/.2.0 +. 10.0
      | FlowingDown => cy2 -. boxHeight2/.2.0 -. 10.0
    }
    
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
  nodeRenderings->Js.Dict.entries->Js.Array2.forEach(((nodeID, rendering: NodeRendering.t)) => {
    let x = (layout.nodeCenterXs->Js.Dict.unsafeGet(nodeID))
    let y = (layout.nodeCenterYs->Js.Dict.unsafeGet(nodeID))
    let gx = x -. (rendering.nodeRelativeCX)
    let gy = y -. (rendering.nodeRelativeCY)
    renderedNodes->Js.Dict.set(nodeID, ({
      gx,
      gy,
      g: rendering.nodeG,
      border: rendering.border,
      label: rendering.label,
      lowerLeftLabel: rendering.lowerLeftLabel,
      upperLeftLabel: rendering.upperLeftLabel,
      upperRightLabel: rendering.upperRightLabel,
      lowerRightLabel: rendering.lowerRightLabel,
      nodeBBox: {
        minX: gx,
        maxX: gx +. rendering.nodeWidth,
        minY: gy,
        maxY: gy +. rendering.nodeHeight,
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

