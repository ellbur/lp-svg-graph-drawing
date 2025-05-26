
module Graph = LPSVGGraphDrawing.Graph
module TextNode = LPSVGGraphDrawing.TextNode
module StringMetrics = LPSVGGraphDrawing.StringMetrics

type orientation = Graph.orientation

let style: TextNode.style = {
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
  edgeRectangularness: 0.75,
}

let graphMetrics: orientation => Graph.graphMetrics = orientation => {
  xSpacing: 40.0,
  ySpacing: 80.0,
  orientation
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

let text = (svg, options) => TextNode.make(document, svg, StringMetrics.NativeBBox, options)
let sourceAttachments = Dict.fromArray([
  ("0", { TextNode.relativeHorizontalFraction: 0.5 })
])
let sinkAttachments = Dict.fromArray([
  ("0", { TextNode.relativeHorizontalFraction: 0.0 }),
  ("m", { TextNode.relativeHorizontalFraction: 0.5 }),
  ("1", { TextNode.relativeHorizontalFraction: 1.0 })
])

let graph: (Element.t, orientation) => Graph.graph = (svg, orientation) => {
  nodes: [
    { id: "a", display: text(svg, {text: "One", annotations: { upperRight: "*" }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "b", display: text(svg, {text: "Two", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "c", display: text(svg, {text: "Three", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "d", display: text(svg, {text: "Four", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "e", display: text(svg, {text: "Five", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "f", display: text(svg, {text: "Six", annotations: { upperRight: "!" }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "g", display: text(svg, {text: "Seven", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
  ],
  edges: [
    { edgeID: "dc",  source: "d", sink: "c", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "a", edgeMetrics },
    { edgeID: "eb",  source: "e", sink: "b", sourceAttachment: "0", sinkAttachment: "m", sinkLabel: "b", edgeMetrics },
    { edgeID: "eg1", source: "e", sink: "g", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "c", edgeMetrics },
    { edgeID: "eg2", source: "e", sink: "g", sourceAttachment: "0", sinkAttachment: "1", sinkLabel: "d", edgeMetrics },
    { edgeID: "gd",  source: "g", sink: "d", sourceAttachment: "0", sinkAttachment: "m", sinkLabel: "e", edgeMetrics },
    { edgeID: "ac",  source: "a", sink: "c", sourceAttachment: "0", sinkAttachment: "1", sinkLabel: "f", edgeMetrics },
    { edgeID: "cf",  source: "c", sink: "f", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "g", edgeMetrics },
    { edgeID: "bf",  source: "b", sink: "f", sourceAttachment: "0", sinkAttachment: "1", sinkLabel: "h", edgeMetrics },
    { edgeID: "ga",  source: "g", sink: "a", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "i", edgeMetrics },
    { edgeID: "ea",  source: "e", sink: "a", sourceAttachment: "0", sinkAttachment: "1", sinkLabel: "j", edgeMetrics },
  ],
  graphMetrics: graphMetrics(orientation)
}

let renderedGraph1 = LPSVGGraphDrawing.renderGraph(~document, ~svg=svg1, ~graph = graph(svg1, LPLayout.FlowingUp))

let renderedGraph2 = LPSVGGraphDrawing.renderGraph(~document, ~svg=svg2, ~graph = graph(svg2, FlowingDown))

