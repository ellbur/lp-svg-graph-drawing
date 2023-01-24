
module Graph = LPSVGGraphDrawing.Graph

let nodeMetrics: Graph.nodeMetrics = {
  nodeBorderStrokeWidth: "1",
  nodeHorizontalPadding: 12.0,
  nodeVerticalPadding: 12.0,
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
    { id: "a", text: "Alice", nodeAnnotations: { lowerLeft: "ll", upperLeft: "ul", lowerRight: "lr", upperRight: "ur" }, nodeMetrics },
    { id: "b", text: "Bob", nodeAnnotations: { lowerLeft: "bbbbbbbb", lowerRight: "BBBBBBBBBBBBBBBBBBBBB" }, nodeMetrics },
    { id: "c", text: "Carole", nodeAnnotations: { upperLeft: "CCCCCC" }, nodeMetrics },
  ],
  edges: [
    { edgeID: "ba", source: "b", sink: "a", sinkPos: -1.0, sinkLabel: "ba", edgeMetrics },
    { edgeID: "ca", source: "c", sink: "a", sinkPos: +1.0, sinkLabel: "ca", edgeMetrics },
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

LPSVGGraphDrawing.renderGraph(~document, ~svg, ~graph)->ignore

