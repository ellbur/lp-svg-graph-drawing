
type nodeMetrics = {
  nodeBorderStrokeWidth: string,
  nodeHorizontalPadding: float,
  nodeVerticalPadding: float,
  nodeFontSize: string,
  nodeFontFamily: string,
  nodeSideTextFontSize: string,
  nodeSideTextFontFamily: string,
  nodeSideTextXOffset: float,
  nodeRoundingX: float,
  nodeRoundingY: float,
}

type nodeAnnotations = {
  lowerLeft?: string,
  upperLeft?: string,
  lowerRight?: string,
  upperRight?: string,
}

type node = {
  id: string,
  text: string,
  nodeAnnotations: nodeAnnotations,
  nodeMetrics: nodeMetrics,
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
  sinkPos: float,
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

