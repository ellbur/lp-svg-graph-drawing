
A small ReScript library for drawing hierarchies with SVG. It is based on [react](https://reactjs.org), and gives you a react component.

<svg height="460" width="307.98699951171875">
	<defs>
		<marker id="arrow" markerHeight="10" markerUnits="userSpaceOnUse" markerWidth="10" orient="auto" refX="0" refY="5" viewBox="0 0 10 10">
			<path d="M 0 0 L 10 5 L 0 10 z" fill="#999"></path>
		</marker>
	</defs>
	<g>
		<rect class="node-border" fill="none" rx="5" ry="5" stroke="#999" stroke-width="1" width="48.40625" height="32" x="128.48568289620536" y="214"></rect>
		<text class="node-text" dominant-baseline="middle" font-family="monospace" font-size="18" text-anchor="middle" x="152.68880789620536" y="230">One</text>
		<text class="node-side-text" dominant-baseline="auto" font-family="monospace" font-size="14" text-anchor="start" x="181.89193289620536" y="230">1</text>
		<rect class="node-border" fill="none" rx="5" ry="5" stroke="#999" stroke-width="1" width="48.40625" height="32" x="226.17449079241072" y="122"></rect>
		<text class="node-text" dominant-baseline="middle" font-family="monospace" font-size="18" text-anchor="middle" x="250.37761579241072" y="138">Two</text>
		<text class="node-side-text" dominant-baseline="auto" font-family="monospace" font-size="14" text-anchor="start" x="279.5807407924107" y="138">2</text>
		<rect class="node-border" fill="none" rx="5" ry="5" stroke="#999" stroke-width="1" width="70" height="32" x="20" y="122"></rect>
		<text class="node-text" dominant-baseline="middle" font-family="monospace" font-size="18" text-anchor="middle" x="55" y="138">Three</text>
		<text class="node-side-text" dominant-baseline="auto" font-family="monospace" font-size="14" text-anchor="start" x="95" y="138">3</text>
		<rect class="node-border" fill="none" rx="5" ry="5" stroke="#999" stroke-width="1" width="59.3997802734375" height="32" x="25.30010986328125" y="214"></rect>
		<text class="node-text" dominant-baseline="middle" font-family="monospace" font-size="18" text-anchor="middle" x="55" y="230">Four</text>
		<text class="node-side-text" dominant-baseline="auto" font-family="monospace" font-size="14" text-anchor="start" x="89.69989013671875" y="230">4</text>
		<rect class="node-border" fill="none" rx="5" ry="5" stroke="#999" stroke-width="1" width="59.203125" height="32" x="180.77605307729092" y="398"></rect>
		<text class="node-text" dominant-baseline="middle" font-family="monospace" font-size="18" text-anchor="middle" x="210.37761557729092" y="414">Five</text>
		<text class="node-side-text" dominant-baseline="auto" font-family="monospace" font-size="14" text-anchor="start" x="244.97917807729092" y="414">5</text>
		<rect class="node-border" fill="none" rx="5" ry="5" stroke="#999" stroke-width="1" width="48.40625" height="32" x="128.48568289620536" y="30"></rect>
		<text class="node-text" dominant-baseline="middle" font-family="monospace" font-size="18" text-anchor="middle" x="152.68880789620536" y="46">Six</text>
		<text class="node-side-text" dominant-baseline="auto" font-family="monospace" font-size="14" text-anchor="start" x="181.89193289620536" y="46">6</text>
		<rect class="node-border" fill="none" rx="5" ry="5" stroke="#999" stroke-width="1" width="70" height="32" x="20" y="306"></rect>
		<text class="node-text" dominant-baseline="middle" font-family="monospace" font-size="18" text-anchor="middle" x="55" y="322">Seven</text>
		<text class="node-side-text" dominant-baseline="auto" font-family="monospace" font-size="14" text-anchor="start" x="95" y="322">7</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 55 214 C 55 164 28 214 28 164"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="36" y="159">a</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 210.37761557729092 398 C 210.37761557729092 322 250.37761579241072 398 250.37761579241072 322 C 250.37761579241072 230 250.37761579241072 322 250.37761579241072 230 C 250.37761579241072 164 250.37761579241072 230 250.37761579241072 164"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="258.3776157924107" y="159">b</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 210.37761557729092 398 C 210.37761557729092 348 28 398 28 348"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="36" y="343">c</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 210.37761557729092 398 C 210.37761557729092 348 82 398 82 348"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="90" y="343">d</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 55 306 C 55 256 55 306 55 256"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="63" y="251">e</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 152.68880789620536 214 C 152.68880789620536 164 82 214 82 164"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="90" y="159">f</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 55 122 C 55 72 135.40599539620536 122 135.40599539620536 72"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="143.40599539620536" y="67">g</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 250.37761579241072 122 C 250.37761579241072 72 169.97162039620537 122 169.97162039620537 72"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="177.97162039620537" y="67">h</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 55 306 C 55 256 135.40599539620536 306 135.40599539620536 256"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="143.40599539620536" y="251">i</text>
		<path class="edge" fill="none" marker-end="url(#arrow)" stroke="#999" stroke-width="1" d="M 210.37761557729092 398 C 210.37761557729092 322 210.37761557729092 398 210.37761557729092 322 C 210.37761557729092 256 169.97162039620537 322 169.97162039620537 256"></path>
		<text class="edge-sink-text" dominant-baseline="hanging" font-family="monospace" font-size="14" text-anchor="start" x="177.97162039620537" y="251">j</text>
	</g>
</svg>


# Installation

```sh
npm i @ellbur/lp-svg-graph-drawing
```

# Usage

```rescript
module GraphDisplay = LPSVGGraphDrawing.GraphDisplay
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

let container = ReactDOM.querySelector("#root")->Belt.Option.getExn
let root = ReactDOM.Client.createRoot(container)
root->ReactDOM.Client.Root.render(<GraphDisplay graph/>)
```

## From JavaScript

The only difference from JavaScript is that due to an [unavoidable name collision](https://forum.rescript-lang.org/t/it-is-possible-to-directly-name-a-react-component-and-avoid-the-make-convention/938/19), the component name is `GraphDisplayJS`:

```javascript
'use strict';

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

import React from 'react';
import { createRoot } from 'react-dom/client';

const root = createRoot(document.getElementById('root'));

import {GraphDisplayJS} from '@ellbur/lp-svg-graph-drawing';
console.log("GraphDisplayJS", GraphDisplayJS);

root.render(<GraphDisplayJS graph={graph}/>);
```

