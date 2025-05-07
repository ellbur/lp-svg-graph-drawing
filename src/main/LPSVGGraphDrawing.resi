
module Graph = LPSVGGraphDrawing_Graph
module RenderedGraph = LPSVGGraphDrawing_RenderedGraph

type stringMetrics = {
  stringWidth: float,
  stringHeight: float
}
type textSizer = NativeBBox | Calculated((string, ~fontFamily: string, ~fontSize: string) => stringMetrics)

let renderGraph: (~document: Webapi.Dom.Document.t, ~svg: Webapi.Dom.Element.t, ~graph: Graph.graph, ~textSizer: textSizer = ?) => RenderedGraph.t

