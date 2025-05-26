
module Graph = LPSVGGraphDrawing.Graph
module TextNode = LPSVGGraphDrawing.TextNode
module StringMetrics = LPSVGGraphDrawing.StringMetrics

let style: TextNode.style = {
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

let graph: Graph.graph = {
  nodes: [
    { id: "a",
      display: TextNode.make(document, svg, StringMetrics.NativeBBox, {
        text: "Alice",
        sourceAttachments: Dict.fromArray([ ]),
        sinkAttachments: Dict.fromArray([
          ("0", { TextNode.relativeHorizontalFraction: 0.0 }),
          ("1", { TextNode.relativeHorizontalFraction: 1.0 }),
        ]),
        annotations: {
          lowerLeft: "ll",
          upperLeft: "ul",
          lowerRight: "lr",
          upperRight: "ur"
        },
        style,
        orientation
      })
    },
    { id: "b",
      display: TextNode.make(document, svg, StringMetrics.NativeBBox, {
        text: "Alice",
        sourceAttachments: Dict.fromArray([
          ("0", { TextNode.relativeHorizontalFraction: 0.5 })
        ]),
        sinkAttachments: Dict.fromArray([ ]),
        annotations: {
          lowerLeft: "ll",
          upperLeft: "ul",
          lowerRight: "lr",
          upperRight: "ur"
        },
        style,
        orientation
      })
    },
    { id: "c",
      display: TextNode.make(document, svg, StringMetrics.NativeBBox, {
        text: "Alice",
        sourceAttachments: Dict.fromArray([
          ("0", { TextNode.relativeHorizontalFraction: 0.5 })
        ]),
        sinkAttachments: Dict.fromArray([ ]),
        annotations: {
          lowerLeft: "ll",
          upperLeft: "ul",
          lowerRight: "lr",
          upperRight: "ur"
        },
        style,
        orientation
      })
    },
  ],
  edges: [
    { edgeID: "ba", source: "b", sink: "a", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "ba", edgeMetrics },
    { edgeID: "ca", source: "c", sink: "a", sourceAttachment: "0", sinkAttachment: "0", sinkLabel: "ca", edgeMetrics },
  ],
  graphMetrics
}

LPSVGGraphDrawing.renderGraph(~document, ~svg, ~graph)->ignore

