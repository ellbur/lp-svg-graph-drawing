
module Graph = LPSVGGraphDrawing_Graph
module RenderedGraph = LPSVGGraphDrawing_RenderedGraph

let renderGraph: (~document: Webapi.Dom.Document.t, ~svg: Webapi.Dom.Element.t, ~graph: Graph.graph) => RenderedGraph.t

