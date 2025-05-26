
type node = {
  id: string,
  display: LPSVGGraphDrawing_NodeDisplay.t
}

type edgeMetrics = {
  edgeStrokeWidth: string,
  edgeSinkLabelFontSize: string,
  edgeSinkLabelFontFamily: string,
  edgeSinkLabelXOffset: float,
  edgeSinkLabelYOffset: float,
  edgeRectangularness: float,
}

type edge = {
  edgeID: string,
  source: string,
  sink: string,
  sourceAttachment: string,
  sinkAttachment: string,
  sinkLabel: string,
  edgeMetrics: edgeMetrics,
}

type orientation = LPLayout.orientation

type graphMetrics = {
  xSpacing: float,
  ySpacing: float,
  orientation: orientation
}

type graph = {
  nodes: array<node>,
  edges: array<edge>,
  graphMetrics: graphMetrics,
}

