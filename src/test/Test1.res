
Js.Console.log("Yo")

open LPLayout.Graph

let actualWidth = 35.0
let actualHeight = 35.0

let layoutWidth = actualWidth *. 1.75
let layoutHeight = actualHeight *. 2.5

let w = layoutWidth
let h = layoutHeight

let graph = {
  nodes: [
    { id: "a", width: w, height: h },
    { id: "b", width: w, height: h },
    { id: "c", width: w, height: h },
    { id: "d", width: w, height: h },
    { id: "e", width: w, height: h },
    { id: "f", width: w, height: h },
    { id: "g", width: w, height: h },
    { id: "h", width: w, height: h },
    { id: "i", width: w, height: h },
    { id: "j", width: w, height: h },
    { id: "k", width: w, height: h },
    { id: "l", width: w, height: h },
    { id: "m", width: w, height: h },
    { id: "x", width: w, height: h },
    { id: "z", width: w, height: h },
  ],
  edges: [
    { edgeID: "ba", source: "b", sink: "a", sinkPos: -1.0 },
    { edgeID: "xa", source: "x", sink: "a", sinkPos: +1.0 },
    { edgeID: "cx", source: "c", sink: "x", sinkPos: +1.0 },
    { edgeID: "db", source: "d", sink: "b", sinkPos: -1.0 },
    { edgeID: "eb", source: "e", sink: "b", sinkPos: +1.0 },
    { edgeID: "fc", source: "f", sink: "c", sinkPos: -1.0 },
    { edgeID: "gc", source: "g", sink: "c", sinkPos: +1.0 },
    { edgeID: "hg", source: "h", sink: "g", sinkPos:  0.0 },
    { edgeID: "ih", source: "i", sink: "h", sinkPos:  0.0 },
    { edgeID: "ji", source: "j", sink: "i", sinkPos: -1.0 },
    { edgeID: "ki", source: "k", sink: "i", sinkPos: +1.0 },
    { edgeID: "lf", source: "l", sink: "f", sinkPos: -1.0 },
    { edgeID: "mf", source: "m", sink: "f", sinkPos: +1.0 },
    { edgeID: "ex", source: "e", sink: "x", sinkPos: -1.0 },
    { edgeID: "le", source: "l", sink: "e", sinkPos:  0.0 },
    { edgeID: "ld", source: "l", sink: "d", sinkPos: +1.0 },
    { edgeID: "im", source: "i", sink: "m", sinkPos:  0.0 },
    { edgeID: "zd", source: "z", sink: "d", sinkPos: -1.0 },
  ]
}

let {LPLayout.nodeCenterXs: cxs, LPLayout.nodeCenterYs: cys} = LPLayout.doLayout(graph, {xSpacing: 20.0, ySpacing: 30.0})

let dots = {
  let {nodes} = graph
  React.array(nodes->Belt.Array.flatMap(({id}) => {
    let cx = cxs->Js.Dict.unsafeGet(id)
    let cy = cys->Js.Dict.unsafeGet(id)

    let lx = cx -. actualWidth/.2.0
    let ly = cy -. actualHeight/.2.0
    
    [
      <rect key={id ++ "_border"} 
        x={lx->Belt.Float.toString}
        y={ly->Belt.Float.toString}
        width={actualWidth->Belt.Float.toString}
        height={actualHeight->Belt.Float.toString} 
        rx="5"
        ry="5"
        fill="none" stroke="#999"
      />,
      <text key={id ++ "_text"}
        x={cx->Belt.Float.toString}
        y={cy->Belt.Float.toString}
        textAnchor="middle"
        dominantBaseline="middle"
        fontSize="18"
        fontFamily="monospace"
        stroke="none"
        fill="#fff"
      >
        {React.string(id)}
      </text>
    ]
  }))
}

let arrows = {
  let {edges} = graph
  React.array(edges->Belt.Array.map(({edgeID, source, sink, sinkPos}) => {
    let cx1 = cxs->Js.Dict.unsafeGet(source)
    let cy1 = cys->Js.Dict.unsafeGet(source)
    
    let cx2 = cxs->Js.Dict.unsafeGet(sink)
    let cy2 = cys->Js.Dict.unsafeGet(sink)
    
    let x1 = cx1
    let y1 = cy1 -. actualHeight/.2.0
    
    let x2 = cx2 +. sinkPos*.(actualWidth-.10.0)*.0.9/.2.0
    let y2 = cy2 +. actualHeight/.2.0 +. 10.0
    
    let bx1 = x1
    let by1 = 0.25*.y1 +. 0.75*.y2
    
    let bx2 = x2
    let by2 = 0.75*.y1 +. 0.25*.y2
    
    let ts = Belt.Float.toString
    
    <path key={edgeID}
      d={`M ${ts(x1)} ${ts(y1)} C ${ts(bx1)} ${ts(by1)} ${ts(bx2)} ${ts(by2)} ${ts(x2)} ${ts(y2)}`}
      fill="none"
      stroke="#999"
      strokeWidth="1"
      markerEnd="url(#arrow)"
    />
  }))
}

let element =
  <svg width="500" height="800">
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

let container = ReactDOM.querySelector("#root")->Belt.Option.getExn
let root = ReactDOM.Client.createRoot(container)
root->ReactDOM.Client.Root.render(element)

