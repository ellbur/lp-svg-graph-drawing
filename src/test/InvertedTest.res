
module Graph = LPSVGGraphDrawing.Graph
type orientation = Graph.orientation

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
  edgeSinkLabelYOffset: 7.0,
  edgeRectangularness: 1.0,
}

let graphMetrics: orientation => Graph.graphMetrics = orientation => {
  xSpacing: 40.0,
  ySpacing: 60.0,
  orientation
}

let graph: orientation => Graph.graph = orientation => {
  nodes: [
    { id: "a", text: "One", nodeAnnotations: { upperRight: "*" }, nodeMetrics },
    { id: "b", text: "Two", nodeAnnotations: { }, nodeMetrics },
    { id: "c", text: "Three", nodeAnnotations: { }, nodeMetrics },
    { id: "d", text: "Four", nodeAnnotations: { }, nodeMetrics },
    { id: "e", text: "Five", nodeAnnotations: { }, nodeMetrics },
    { id: "f", text: "Six", nodeAnnotations: { upperRight: "!" }, nodeMetrics },
    { id: "g", text: "Seven", nodeAnnotations: { }, nodeMetrics },
  ],
  edges: [
    { edgeID: "dc",  source: "d", sink: "c", sinkPos: -1.0, sinkLabel: "a", edgeMetrics },
    { edgeID: "eb",  source: "e", sink: "b", sinkPos:  0.0, sinkLabel: "b", edgeMetrics },
    { edgeID: "eg1", source: "e", sink: "g", sinkPos: -1.0, sinkLabel: "c", edgeMetrics },
    { edgeID: "eg2", source: "e", sink: "g", sinkPos: +1.0, sinkLabel: "d", edgeMetrics },
    { edgeID: "gd",  source: "g", sink: "d", sinkPos:  0.0, sinkLabel: "e", edgeMetrics },
    { edgeID: "ac",  source: "a", sink: "c", sinkPos: +1.0, sinkLabel: "f", edgeMetrics },
    { edgeID: "cf",  source: "c", sink: "f", sinkPos: -1.0, sinkLabel: "g", edgeMetrics },
    { edgeID: "bf",  source: "b", sink: "f", sinkPos: +1.0, sinkLabel: "h", edgeMetrics },
    { edgeID: "ga",  source: "g", sink: "a", sinkPos: -1.0, sinkLabel: "i", edgeMetrics },
    { edgeID: "ea",  source: "e", sink: "a", sinkPos: +1.0, sinkLabel: "j", edgeMetrics },
  ],
  graphMetrics: graphMetrics(orientation)
}

module Document = Webapi.Dom.Document
module Element = Webapi.Dom.Element
let document = Webapi.Dom.document

let svgNS = "http://www.w3.org/2000/svg"

let container = document->Document.getElementById("root")->Belt.Option.getExn

let svg1 = document->Document.createElementNS(svgNS, "svg")
container->Element.appendChild(~child=svg1)

let svg2 = document->Document.createElementNS(svgNS, "svg")
container->Element.appendChild(~child=svg2)

let renderedGraph1 = LPSVGGraphDrawing.renderGraph(~document, ~svg=svg1, ~graph = graph(FlowingUp))

let renderedGraph2 = LPSVGGraphDrawing.renderGraph(~document, ~svg=svg2, ~graph = graph(FlowingDown))

