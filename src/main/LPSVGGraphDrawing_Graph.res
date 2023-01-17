
type node = {
  id: string,
  text: string,
  sideText: string,
  borderStrokeWidth: string,
  borderStrokeColor: string,
}

type edge = {
  edgeID: string,
  source: string,
  sink: string,
  sinkPos: float,
  edgeStrokeWidth: string,
  edgeStrokeColor: string,
  sinkLabel: string,
}

type graph = {
  nodes: array<node>,
  edges: array<edge>,
}

