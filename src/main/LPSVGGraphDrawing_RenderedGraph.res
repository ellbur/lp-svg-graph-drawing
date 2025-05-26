
module Element = Webapi.Dom.Element

type bbox = {
  minX: float,
  maxX: float,
  minY: float,
  maxY: float
}

type renderedNode = {
  gx: float,
  gy: float,
  g: Element.t,
  nodeBBox: bbox
}

type renderedEdge = {
  path: Element.t,
  sinkLabel: Element.t,
  edgeBBox: bbox
}

type t = {
  nodes: Js.Dict.t<renderedNode>,
  edges: Js.Dict.t<renderedEdge>,
  layout: LPLayout.layout,
}

