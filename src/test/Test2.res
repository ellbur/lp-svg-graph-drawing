
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
    let pathElems = Js.Dict.empty()
    
    let dots = {
      let {Graph.nodes: nodes} = graph
      React.array(nodes->Belt.Array.flatMap(({id, text}) => {
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
          </text>
        ]
      }))
    }

    let arrows = {
      let {edges} = graph
      React.array(edges->Belt.Array.map(({edgeID}) => {
        <path
          ref={ReactDOM.Ref.callbackDomRef(pathElems->Js.Dict.set(edgeID))}
          key={edgeID}
          fill="none"
          stroke="#999"
          strokeWidth="1"
          markerEnd="url(#arrow)"
        />
      }))
    }
    
    let adjustLayout = () => {
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
        rectElem->Webapi.Dom.Element.setAttribute("width", boxWidth->Belt.Float.toString)
        rectElem->Webapi.Dom.Element.setAttribute("height", boxHeight->Belt.Float.toString)
        
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
      
      let {nodeCenterXs, nodeCenterYs} = LPLayout.doLayout(lpGraph)
      
      graph.nodes->Belt.Array.forEach(node => {
        let {id} = node
        
        let cx = nodeCenterXs->Js.Dict.unsafeGet(id)
        let cy = nodeCenterYs->Js.Dict.unsafeGet(id)
        
        let boxWidth = boxWidths->Js.Dict.unsafeGet(id)
        let boxHeight = boxHeights->Js.Dict.unsafeGet(id)
        
        let textElem = textElems->Js.Dict.unsafeGet(id)->Js.Nullable.toOption->Belt.Option.getUnsafe
        let rectElem = rectElems->Js.Dict.unsafeGet(id)->Js.Nullable.toOption->Belt.Option.getUnsafe
        
        textElem->Webapi.Dom.Element.setAttribute("x", cx->Belt.Float.toString)
        textElem->Webapi.Dom.Element.setAttribute("y", cy->Belt.Float.toString)
        
        rectElem->Webapi.Dom.Element.setAttribute("x", (cx -. boxWidth/.2.0)->Belt.Float.toString)
        rectElem->Webapi.Dom.Element.setAttribute("y", (cy -. boxHeight/.2.0)->Belt.Float.toString)
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
        
        let x1 = cx1
        let y1 = cy1 -. boxHeight1/.2.0
        
        let x2 = cx2 +. sinkPos*.(boxWidth2-.10.0)*.0.9/.2.0
        let y2 = cy2 +. boxHeight2/.2.0 +. 10.0
        
        let bx1 = x1
        let by1 = 0.25*.y1 +. 0.75*.y2
        
        let bx2 = x2
        let by2 = 0.75*.y1 +. 0.25*.y2
        
        let ts = Belt.Float.toString
        pathElem->Webapi.Dom.Element.setAttribute("d",
          `M ${ts(x1)} ${ts(y1)} C ${ts(bx1)} ${ts(by1)} ${ts(bx2)} ${ts(by2)} ${ts(x2)} ${ts(y2)}`
        )
      })
    }
    
    <svg ref={ReactDOM.Ref.callbackDomRef(_ => adjustLayout())} width="500" height="800">
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
      dots
      arrows
    </svg>
  }
}

let graph: Graph.graph = {
  nodes: [
    { id: "a", text: "Alice", sideText: "", borderStrokeWidth: "1", borderStrokeColor: "#999" },
    { id: "b", text: "Bob", sideText: "", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
    { id: "c", text: "Caroline", sideText: "", borderStrokeWidth: "1", borderStrokeColor: "#999"  },
  ],
  edges: [
    { edgeID: "ba", source: "b", sink: "a", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "" },
    { edgeID: "ca", source: "c", sink: "a", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "" },
  ]
}

let container = ReactDOM.querySelector("#root")->Belt.Option.getExn
let root = ReactDOM.Client.createRoot(container)
root->ReactDOM.Client.Root.render(<GraphDisplay graph/>)

