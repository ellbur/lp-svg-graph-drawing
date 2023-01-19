
module Graph = LPSVGGraphDrawing_Graph

module GraphDisplay: {
  @react.component
  let make: (~graph: Graph.graph) => React.element
}

let \"GraphDisplayJS": React.componentLike<GraphDisplay.props<Graph.graph>, React.element>

