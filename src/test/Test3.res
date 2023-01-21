
module Graph = LPSVGGraphDrawing.Graph

let nodeMetrics: Graph.nodeMetrics = {
  nodeBorderStrokeWidth: "1",
  nodeHorizontalPadding: 8.0,
  nodeVerticalPadding: 4.0,
  nodeFontSize: "18",
  nodeFontFamily: "monospace",
  nodeSideTextFontSize: "14",
  nodeSideTextFontFamily: "monospace",
  nodeSideTextXOffset: 5.0,
  nodeRoundingX: 5.0,
  nodeRoundingY: 5.0,
}

let edgeMetrics: Graph.edgeMetrics = {
  edgeStrokeWidth: "1",
  edgeSinkLabelFontSize: "14",
  edgeSinkLabelFontFamily: "monospace",
  edgeSinkLabelXOffset: 8.0,
  edgeSinkLabelYOffset: -5.0,
  edgeRectangularness: 1.0,
}

let graphMetrics: Graph.graphMetrics = {
  xSpacing: 40.0,
  ySpacing: 60.0,
}

let graph: Graph.graph = {
  nodes: [
    { id: "a", text: "Alice", sideText: "!", nodeMetrics },
    { id: "b", text: "Bob", sideText: "?", nodeMetrics },
    { id: "c", text: "Caroline", sideText: "*", nodeMetrics },
    { id: "d", text: "Dave", sideText: "\"", nodeMetrics },
    { id: "e", text: "Edward", sideText: "&", nodeMetrics },
    { id: "f", text: "Fred", sideText: "&", nodeMetrics },
    { id: "g", text: "Gus", sideText: "&", nodeMetrics },
  ],
  edges: [
    { edgeID: "dc",  source: "d", sink: "c", sinkPos: -1.0, sinkLabel: ".", edgeMetrics },
    { edgeID: "eb",  source: "e", sink: "b", sinkPos:  0.0, sinkLabel: ",", edgeMetrics },
    { edgeID: "eg1", source: "e", sink: "g", sinkPos: -1.0, sinkLabel: "/", edgeMetrics },
    { edgeID: "eg2", source: "e", sink: "g", sinkPos: +1.0, sinkLabel: "/", edgeMetrics },
    { edgeID: "gd",  source: "g", sink: "d", sinkPos:  0.0, sinkLabel: "/", edgeMetrics },
    { edgeID: "ac",  source: "a", sink: "c", sinkPos: +1.0, sinkLabel: "/", edgeMetrics },
    { edgeID: "cf",  source: "c", sink: "f", sinkPos: -1.0, sinkLabel: "/", edgeMetrics },
    { edgeID: "bf",  source: "b", sink: "f", sinkPos: +1.0, sinkLabel: "/", edgeMetrics },
    { edgeID: "ga",  source: "g", sink: "a", sinkPos: -1.0, sinkLabel: "/", edgeMetrics },
    { edgeID: "ea",  source: "e", sink: "a", sinkPos: +1.0, sinkLabel: "/", edgeMetrics },
  ],
  graphMetrics
}

module Document = Webapi.Dom.Document
module Element = Webapi.Dom.Element
let document = Webapi.Dom.document

let svgNS = "http://www.w3.org/2000/svg"

let container = document->Document.getElementById("root")->Belt.Option.getExn
let svg = document->Document.createElementNS(svgNS, "svg")
container->Element.appendChild(~child=svg)

LPSVGGraphDrawing.renderGraph(~document, ~svg, ~graph)

