
module Graph = LPSVGGraphDrawing.Graph
module TextNode = LPSVGGraphDrawing.TextNode
module StringMetrics = LPSVGGraphDrawing.StringMetrics

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
  edgeSinkLabelYOffset: 5.0,
  edgeRectangularness: 1.0,
}

let orientation = LPLayout.FlowingDown

let graphMetrics: Graph.graphMetrics = {
  xSpacing: 40.0,
  ySpacing: 60.0,
  orientation
}

module Document = Webapi.Dom.Document
module Element = Webapi.Dom.Element
let document = Webapi.Dom.document

let svgNS = "http://www.w3.org/2000/svg"

let container = document->Document.getElementById("root")->Belt.Option.getExn
let svg = document->Document.createElementNS(svgNS, "svg")
container->Element.appendChild(~child=svg)

let text = options => TextNode.make(document, svg, StringMetrics.NativeBBox, options)
let sourceAttachments = Dict.fromArray([
  ("0", { TextNode.relativeHorizontalFraction: 0.5 })
])
let sinkAttachments = Dict.fromArray([
  ("0", { TextNode.relativeHorizontalFraction: 0.0 }),
  ("m", { TextNode.relativeHorizontalFraction: 0.5 }),
  ("1", { TextNode.relativeHorizontalFraction: 1.0 })
])

let graph: Graph.graph = {
  nodes: [
    { id: "a", display: text({text: "Alice", annotations: { lowerLeft: "aa", upperRight: "aaaaa" }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "b", display: text({text: "Bob", annotations: { upperLeft: "b b", lowerRight: "?" }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "c", display: text({text: "Caroline", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "d", display: text({text: "Dave", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "e", display: text({text: "Edward", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "f", display: text({text: "Fred", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
    { id: "g", display: text({text: "Gus", annotations: { }, sourceAttachments, sinkAttachments, style, orientation }) },
  ],
  edges: [
    { edgeID: "dc",  source: "d", sink: "c", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: ".", edgeMetrics },
    { edgeID: "eb",  source: "e", sink: "b", sourceAttachment: "0", sinkAttachment: "m", sinkLabel: "abcdefgh", edgeMetrics },
    { edgeID: "eg1", source: "e", sink: "g", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "/", edgeMetrics },
    { edgeID: "eg2", source: "e", sink: "g", sourceAttachment: "0", sinkAttachment: "1", sinkLabel: "/", edgeMetrics },
    { edgeID: "gd",  source: "g", sink: "d", sourceAttachment: "0", sinkAttachment: "m", sinkLabel: "/", edgeMetrics },
    { edgeID: "ac",  source: "a", sink: "c", sourceAttachment: "0", sinkAttachment: "1", sinkLabel: "/", edgeMetrics },
    { edgeID: "cf",  source: "c", sink: "f", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "/", edgeMetrics },
    { edgeID: "bf",  source: "b", sink: "f", sourceAttachment: "0", sinkAttachment: "1", sinkLabel: "/", edgeMetrics },
    { edgeID: "ga",  source: "g", sink: "a", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "/", edgeMetrics },
    { edgeID: "ea",  source: "e", sink: "a", sourceAttachment: "0", sinkAttachment: "1", sinkLabel: "/", edgeMetrics },
  ],
  graphMetrics
}

LPSVGGraphDrawing.renderGraph(~document, ~svg, ~graph)->ignore

