
A small ReScript library for drawing hierarchies with SVG.

![sample diagraph](https://raw.githubusercontent.com/ellbur/lp-svg-graph-drawing/main/example.svg?token=GHSAT0AAAAAAB5GCAHSVTSD7VR5WJJJIR74Y6IYFWA)

# Installation

```sh
npm i @ellbur/lp-svg-graph-drawing
```

# Usage

```rescript
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
    { id: "a", text: "One", sideText: "1", nodeMetrics },
    { id: "b", text: "Two", sideText: "2", nodeMetrics },
    { id: "c", text: "Three", sideText: "3", nodeMetrics },
    { id: "d", text: "Four", sideText: "4", nodeMetrics },
    { id: "e", text: "Five", sideText: "5", nodeMetrics },
    { id: "f", text: "Six", sideText: "6", nodeMetrics },
    { id: "g", text: "Seven", sideText: "7", nodeMetrics },
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
```

## From JavaScript

```javascript
const nodeMetrics = {
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
};

const edgeMetrics = {
  edgeStrokeWidth: "1",
  edgeSinkLabelFontSize: "14",
  edgeSinkLabelFontFamily: "monospace",
  edgeSinkLabelXOffset: 8.0,
  edgeSinkLabelYOffset: -5.0,
  edgeRectangularness: 1.0,
};

const graphMetrics = {
  xSpacing: 40.0,
  ySpacing: 60.0,
};

const graph = {
  nodes: [
    { id: "a", text: "One", sideText: "1", nodeMetrics },
    { id: "b", text: "Two", sideText: "2", nodeMetrics },
    { id: "c", text: "Three", sideText: "3", nodeMetrics },
    { id: "d", text: "Four", sideText: "4", nodeMetrics },
    { id: "e", text: "Five", sideText: "5", nodeMetrics },
    { id: "f", text: "Six", sideText: "6", nodeMetrics },
    { id: "g", text: "Seven", sideText: "7", nodeMetrics },
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
  graphMetrics
};

const container = document.getElementById('root');

let svgNS = "http://www.w3.org/2000/svg";

let svg = document.createElementNS(svgNS, "svg");
container.appendChild(svg);

import {renderGraph} from 'lp-svg-graph-drawing';

renderGraph(document, svg, graph);
```

