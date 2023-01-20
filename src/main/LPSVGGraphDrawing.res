
module Graph = LPSVGGraphDrawing_Graph

module Document = Webapi.Dom.Document
module Element = Webapi.Dom.Element

module SVGRect = {
  type t = {
    x: float,
    y: float,
    width: float,
    height: float
  }
}

@send external getBBox: Dom.element => SVGRect.t = "getBBox"

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

let renderGraph = (document: Document.t, svg: Element.t, graph: Graph.graph) => {
  let {rect, text, defs, marker, path, g} = module(LPSVGGraphDrawing_SVGUtils)
  
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
          ()
        )
      ],
      ()
    )
  ]))
  
  let mainG = document->g(~children=[])
  svg->Element.appendChild(~child=mainG)
  
  let rectElems = Js.Dict.empty()
  let textElems = Js.Dict.empty()
  let sideTextElems = Js.Dict.empty()
  let pathElems = Js.Dict.empty()
  let sinkLabelElems = Js.Dict.empty()
  
  {
    let {Graph.nodes: nodes} = graph
    nodes->Belt.Array.forEach(({id, text: label, sideText, nodeMetrics}) => {
      let nodeRect = document->rect(
        ~rx=nodeMetrics.nodeRoundingX->Belt.Float.toString,
        ~ry=nodeMetrics.nodeRoundingY->Belt.Float.toString,
        ~fill="none",
        ~strokeWidth=nodeMetrics.nodeBorderStrokeWidth,
        ~class="node-border",
        ~stroke="#999",
        ()
      )
      
      let nodeText = document->text(
        ~textAnchor="middle",
        ~dominantBaseline="middle",
        ~fontSize=nodeMetrics.nodeFontSize,
        ~fontFamily=nodeMetrics.nodeFontFamily,
        ~class="node-text",
        ~textContent=label,
        ()
      )
      
      let nodeSideText = document->text(
        ~textAnchor="start",
        ~dominantBaseline="auto",
        ~fontSize=nodeMetrics.nodeSideTextFontSize,
        ~fontFamily=nodeMetrics.nodeSideTextFontFamily,
        ~class="node-side-text",
        ~textContent=sideText,
        ()
      )
      
      mainG->Element.appendChild(~child=nodeRect)
      mainG->Element.appendChild(~child=nodeText)
      mainG->Element.appendChild(~child=nodeSideText)
      
      rectElems->Js.Dict.set(id, nodeRect)
      textElems->Js.Dict.set(id, nodeText)
      sideTextElems->Js.Dict.set(id, nodeSideText)
    })
  }

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
        
      let edgeSinkText = document->text(
        ~textAnchor="start",
        ~dominantBaseline="hanging",
        ~fontSize=edgeMetrics.edgeSinkLabelFontSize,
        ~fontFamily=edgeMetrics.edgeSinkLabelFontFamily,
        ~class="edge-sink-text",
        ~textContent=sinkLabel,
        ()
      )
      
      mainG->Element.appendChild(~child=edgePath)
      mainG->Element.appendChild(~child=edgeSinkText)
      
      pathElems->Js.Dict.set(edgeID, edgePath)
      sinkLabelElems->Js.Dict.set(edgeID, edgeSinkText)
    })
  }
  
  {
    module F = Graph
    module T = LPLayout.Graph
    
    let boxWidths = Js.Dict.empty()
    let boxFlatWidths = Js.Dict.empty()
    let boxHeights = Js.Dict.empty()
    
    graph.nodes->Belt.Array.forEach(node => {
      let {id, nodeMetrics} = node
      
      let textElem = textElems->Js.Dict.unsafeGet(id)
      let {width: textWidth, height: textHeight} = textElem->getBBox
      
      let boxWidth = textWidth +. 2.0*.nodeMetrics.nodeHorizontalPadding
      let boxHeight = textHeight +. 2.0*.nodeMetrics.nodeVerticalPadding
      
      let rectElem = rectElems->Js.Dict.unsafeGet(id)
      rectElem->setAttribute("width", fts(boxWidth))
      rectElem->setAttribute("height", fts(boxHeight))
      
      boxWidths->Js.Dict.set(id, boxWidth)
      boxFlatWidths->Js.Dict.set(id, boxWidth -. 2.0*.nodeMetrics.nodeRoundingX)
      boxHeights->Js.Dict.set(id, boxHeight)
    })
    
    let lpGraph: T.graph = {
      nodes: graph.nodes->Belt.Array.map(node => {
        let {id} = node
        
        let boxWidth = boxWidths->Js.Dict.unsafeGet(id)
        let boxHeight = boxHeights->Js.Dict.unsafeGet(id)
        
        let layoutWidth = boxWidth
        let layoutHeight = boxHeight
        
        ({
          id: id,
          width: layoutWidth,
          height: layoutHeight
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
    
    let layout = LPLayout.doLayout(lpGraph, {xSpacing: graph.graphMetrics.xSpacing, ySpacing: graph.graphMetrics.ySpacing})
    let {nodeCenterXs, nodeCenterYs, edgeExtraNodes} = layout
    
    graph.nodes->Belt.Array.forEach(node => {
      let {id, nodeMetrics} = node
      
      let cx = nodeCenterXs->Js.Dict.unsafeGet(id)
      let cy = nodeCenterYs->Js.Dict.unsafeGet(id)
      
      let boxWidth = boxWidths->Js.Dict.unsafeGet(id)
      let boxHeight = boxHeights->Js.Dict.unsafeGet(id)
      
      let textElem = textElems->Js.Dict.unsafeGet(id)
      let rectElem = rectElems->Js.Dict.unsafeGet(id)
      let sideTextElem = sideTextElems->Js.Dict.unsafeGet(id)
      
      textElem->setAttribute("x", cx->fts)
      textElem->setAttribute("y", cy->fts)
      
      rectElem->setAttribute("x", fts(cx -. boxWidth/.2.0))
      rectElem->setAttribute("y", fts(cy -. boxHeight/.2.0))
      
      sideTextElem->setAttribute("x", fts(cx +. boxWidth/.2.0 +. nodeMetrics.nodeSideTextXOffset))
      sideTextElem->setAttribute("y", fts(cy))
    })
    
    graph.edges->Belt.Array.forEach(edge => {
      let {edgeID, source, sink, sinkPos, edgeMetrics} = edge
      let pathElem = pathElems->Js.Dict.unsafeGet(edgeID)
      
      let cx1 = nodeCenterXs->Js.Dict.unsafeGet(source)
      let cy1 = nodeCenterYs->Js.Dict.unsafeGet(source)
      
      let cx2 = nodeCenterXs->Js.Dict.unsafeGet(sink)
      let cy2 = nodeCenterYs->Js.Dict.unsafeGet(sink)
      
      let boxHeight1 = boxHeights->Js.Dict.unsafeGet(source)
      let boxFlatWidth2 = boxFlatWidths->Js.Dict.unsafeGet(sink)
      let boxHeight2 = boxHeights->Js.Dict.unsafeGet(sink)
      
      let xStart = cx1
      let yStart = cy1 -. boxHeight1/.2.0
      
      let xEnd = cx2 +. sinkPos*.boxFlatWidth2*.0.9/.2.0
      let yEnd = cy2 +. boxHeight2/.2.0 +. 10.0
      
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
            let p1 = pointsToTravelThrough[i-1]
            let p2 = pointsToTravelThrough[i]
            
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
      
      let sinkLabelElem = sinkLabelElems->Js.Dict.unsafeGet(edgeID)
      sinkLabelElem->setAttribute("x", fts(xEnd +. edgeMetrics.edgeSinkLabelXOffset))
      sinkLabelElem->setAttribute("y", fts(yEnd +. edgeMetrics.edgeSinkLabelYOffset))
    })
    
    let bbox = mainG->getBBox
    let totalWidth = bbox.x*.2.0 +. bbox.width
    let totalHeight = bbox.y*.2.0 +. bbox.height
    svg->setAttribute("width", fts(totalWidth))
    svg->setAttribute("height", fts(totalHeight))
  }
  
}

