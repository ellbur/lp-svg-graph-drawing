
Js.Console.log("Test2")

let todo = () => Js.Exn.raiseError("Not implemented")

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

module Graph = {
  type node = {
    id: string,
    text: string,
    sideText: string,
    borderStrokeWidth: string,
    borderStrokeColor: string,
  }

  type edge = {
    edgeID: string,
    source: string,
    sink: string,
    sinkPos: float,
    edgeStrokeWidth: string,
    edgeStrokeColor: string,
    sinkLabel: string,
  }

  type graph = {
    nodes: array<node>,
    edges: array<edge>,
  }
}

module GraphDisplay = {
  @react.component
  let make = (~graph) => {
    let rectElems = Js.Dict.empty()
    let textElems = Js.Dict.empty()
    let sideTextElems = Js.Dict.empty()
    let pathElems = Js.Dict.empty()
    let sinkLabelElems = Js.Dict.empty()
    let contentGElem = ref(None)
    
    let dots = {
      let {Graph.nodes: nodes} = graph
      React.array(nodes->Belt.Array.flatMap(({id, text, sideText}) => {
        [
          <rect 
            ref={ReactDOM.Ref.callbackDomRef(rectElems->Js.Dict.set(id))}
            key={id ++ "_border"} 
            rx="5"
            ry="5"
            fill="none" stroke="#999"
          />,
          <text
            ref={ReactDOM.Ref.callbackDomRef(textElems->Js.Dict.set(id))}
            key={id ++ "_text"}
            textAnchor="middle"
            dominantBaseline="middle"
            fontSize="18"
            fontFamily="monospace"
            stroke="none"
            fill="#fff"
          >
            {React.string(text)}
          </text>,
          <text
            ref={ReactDOM.Ref.callbackDomRef(sideTextElems->Js.Dict.set(id))}
            key={id ++ "_sideText"}
            textAnchor="start"
            dominantBaseline="auto"
            fontSize="14"
            fontFamily="monospace"
            stroke="none"
            fill="#fff"
          >
            {React.string(sideText)}
          </text>
        ]
      }))
    }

    let arrows = {
      let {edges} = graph
      React.array(edges->Belt.Array.flatMap(({edgeID, sinkLabel}) => {
        [
          <path
            ref={ReactDOM.Ref.callbackDomRef(pathElems->Js.Dict.set(edgeID))}
            key={edgeID ++ "_path"}
            fill="none"
            stroke="#999"
            strokeWidth="1"
            markerEnd="url(#arrow)"
          />,
          <text
            ref={ReactDOM.Ref.callbackDomRef(sinkLabelElems->Js.Dict.set(edgeID))}
            key={edgeID ++ "_sinkLabel"}
            textAnchor="start"
            dominantBaseline="auto"
            fontSize="14"
            fontFamily="monospace"
            stroke="none"
            fill="#fff"
          >
            {React.string(sinkLabel)}
          </text>
        ]
      }))
    }
    
    let adjustLayout = svgElem => {
      module F = Graph
      module T = LPLayout.Graph
      
      let horizontalScaleFactor = 1.50
      let verticalScaleFactor = 2.50
      
      let horizontalPadding = 10.0
      let verticalPadding = 5.0
      
      let boxWidths = Js.Dict.empty()
      let boxHeights = Js.Dict.empty()
      
      graph.nodes->Belt.Array.forEach(node => {
        let {id} = node
        
        let textElem = textElems->Js.Dict.unsafeGet(id)->Js.Nullable.toOption->Belt.Option.getUnsafe
        let {width: textWidth, height: textHeight} = textElem->getBBox
        
        let boxWidth = textWidth +. 2.0*.horizontalPadding
        let boxHeight = textHeight +. 2.0*.verticalPadding
        
        let rectElem = rectElems->Js.Dict.unsafeGet(id)->Js.Nullable.toOption->Belt.Option.getUnsafe
        rectElem->setAttribute("width", fts(boxWidth))
        rectElem->setAttribute("height", fts(boxHeight))
        
        boxWidths->Js.Dict.set(id, boxWidth)
        boxHeights->Js.Dict.set(id, boxHeight)
      })
      
      let lpGraph: T.graph = {
        nodes: graph.nodes->Belt.Array.map(node => {
          let {id} = node
          
          let boxWidth = boxWidths->Js.Dict.unsafeGet(id)
          let boxHeight = boxHeights->Js.Dict.unsafeGet(id)
          
          let layoutWidth = boxWidth *. horizontalScaleFactor
          let layoutHeight = boxHeight *. verticalScaleFactor
          
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
      
      let layout = LPLayout.doLayout(lpGraph)
      Js.Console.log2("layout", layout)
      let {nodeCenterXs, nodeCenterYs, edgeExtraNodes} = layout
      
      graph.nodes->Belt.Array.forEach(node => {
        let {id} = node
        
        let cx = nodeCenterXs->Js.Dict.unsafeGet(id)
        let cy = nodeCenterYs->Js.Dict.unsafeGet(id)
        
        let boxWidth = boxWidths->Js.Dict.unsafeGet(id)
        let boxHeight = boxHeights->Js.Dict.unsafeGet(id)
        
        let textElem = textElems->Js.Dict.unsafeGet(id)->Js.Nullable.toOption->Belt.Option.getUnsafe
        let rectElem = rectElems->Js.Dict.unsafeGet(id)->Js.Nullable.toOption->Belt.Option.getUnsafe
        let sideTextElem = sideTextElems->Js.Dict.unsafeGet(id)->Js.Nullable.toOption->Belt.Option.getUnsafe
        
        textElem->setAttribute("x", cx->fts)
        textElem->setAttribute("y", cy->fts)
        
        rectElem->setAttribute("x", fts(cx -. boxWidth/.2.0))
        rectElem->setAttribute("y", fts(cy -. boxHeight/.2.0))
        
        sideTextElem->setAttribute("x", fts(cx +. boxWidth/.2.0 +. 5.0))
        sideTextElem->setAttribute("y", fts(cy))
      })
      
      graph.edges->Belt.Array.forEach(edge => {
        let {edgeID, source, sink, sinkPos} = edge
        let pathElem = pathElems->Js.Dict.unsafeGet(edgeID)->Js.Nullable.toOption->Belt.Option.getUnsafe
        
        let cx1 = nodeCenterXs->Js.Dict.unsafeGet(source)
        let cy1 = nodeCenterYs->Js.Dict.unsafeGet(source)
        
        let cx2 = nodeCenterXs->Js.Dict.unsafeGet(sink)
        let cy2 = nodeCenterYs->Js.Dict.unsafeGet(sink)
        
        let boxHeight1 = boxHeights->Js.Dict.unsafeGet(source)
        let boxWidth2 = boxWidths->Js.Dict.unsafeGet(sink)
        let boxHeight2 = boxHeights->Js.Dict.unsafeGet(sink)
        
        let xStart = cx1
        let yStart = cy1 -. boxHeight1/.2.0
        
        let xEnd = cx2 +. sinkPos*.(boxWidth2-.10.0)*.0.9/.2.0
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
              let by1 = 0.10*.y1 +. 0.90*.y2

              let bx2 = x2
              let by2 = 0.90*.y1 +. 0.10*.y2
              
              workingD.contents = workingD.contents ++ ` C ${fts(bx1)} ${fts(by1)} ${fts(bx2)} ${fts(by2)} ${fts(x2)} ${fts(y2)}`
              
              step(i + 1)
            }
          }
          step(1)
        }
        
        pathElem->setAttribute("d", workingD.contents)
        
        let sinkLabelElem = sinkLabelElems->Js.Dict.unsafeGet(edgeID)->Js.Nullable.toOption->Belt.Option.getUnsafe
        sinkLabelElem->setAttribute("x", fts(xEnd +. 10.0))
        sinkLabelElem->setAttribute("y", fts(yEnd +. 5.0))
      })
      
      let contentGElem = contentGElem.contents->Belt.Option.getUnsafe
      let bbox = contentGElem->getBBox
      let totalWidth = bbox.x*.2.0 +. bbox.width
      let totalHeight = bbox.y*.2.0 +. bbox.height
      svgElem->setAttribute("width", fts(totalWidth))
      svgElem->setAttribute("height", fts(totalHeight))
    }
    
    <svg ref={ReactDOM.Ref.callbackDomRef(d => adjustLayout(d->Js.Nullable.toOption->Belt.Option.getUnsafe))} width="500" height="500">
      <defs>
        <marker
          id="arrow"
          viewBox="0 0 10 10"
           refX="0"
           refY="5"
           markerUnits="userSpaceOnUse"
           markerWidth="10"
           markerHeight="10"
           orient="auto"
        >
          <path d="M 0 0 L 10 5 L 0 10 z" fill="#999"/>
        </marker>
      </defs>
      <g ref={ReactDOM.Ref.callbackDomRef(d => {contentGElem.contents = d->Js.Nullable.toOption})}>
        dots
        arrows
      </g>
    </svg>
  }
}

let graph: Graph.graph = {
  nodes: [
    { id: "a", text: "Alice", sideText: "!", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
    { id: "b", text: "Bob", sideText: "?", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
    { id: "c", text: "Caroline", sideText: "*", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
    { id: "d", text: "Dave", sideText: "\"", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
    { id: "e", text: "Edward", sideText: "&", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
    { id: "f", text: "Fred", sideText: "&", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
    { id: "g", text: "Gus", sideText: "&", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
  ],
  edges: [
    { edgeID: "dc", source: "d", sink: "c", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "..." },
    { edgeID: "eb", source: "e", sink: "b", sinkPos:  0.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "," },
    { edgeID: "eg1", source: "e", sink: "g", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "eg2", source: "e", sink: "g", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "gd", source: "g", sink: "d", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "ac", source: "a", sink: "c", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "cf", source: "c", sink: "f", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "bf", source: "b", sink: "f", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "ga", source: "g", sink: "a", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "ed", source: "e", sink: "d", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "ea", source: "e", sink: "a", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
  ]
}

let container = ReactDOM.querySelector("#root")->Belt.Option.getExn
let root = ReactDOM.Client.createRoot(container)
root->ReactDOM.Client.Root.render(<GraphDisplay graph/>)

