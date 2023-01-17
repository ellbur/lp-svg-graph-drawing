
module GraphDisplay = LPSVGGraphDrawing.GraphDisplay
module Graph = LPSVGGraphDrawing.Graph

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
    { edgeID: "dc",  source: "d", sink: "c", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "..." },
    { edgeID: "eb",  source: "e", sink: "b", sinkPos:  0.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "," },
    { edgeID: "eg1", source: "e", sink: "g", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "eg2", source: "e", sink: "g", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "gd",  source: "g", sink: "d", sinkPos:  0.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "ac",  source: "a", sink: "c", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "cf",  source: "c", sink: "f", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "bf",  source: "b", sink: "f", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "ga",  source: "g", sink: "a", sinkPos: -1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
    { edgeID: "ea",  source: "e", sink: "a", sinkPos: +1.0, edgeStrokeWidth: "1", edgeStrokeColor: "#999", sinkLabel: "/" },
  ]
}

let container = ReactDOM.querySelector("#root")->Belt.Option.getExn
let root = ReactDOM.Client.createRoot(container)
root->ReactDOM.Client.Root.render(<GraphDisplay graph/>)

