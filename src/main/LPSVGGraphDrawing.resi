
module Graph = LPSVGGraphDrawing_Graph
module RenderedGraph = LPSVGGraphDrawing_RenderedGraph

type stringMetrics = LPSVGGraphDrawing_StringMetrics.stringMetrics
type textSizer = LPSVGGraphDrawing_StringMetrics.textSizer

let renderGraph: (~document: Webapi.Dom.Document.t, ~svg: Webapi.Dom.Element.t, ~graph: Graph.graph, ~textSizer: textSizer = ?) => RenderedGraph.t

