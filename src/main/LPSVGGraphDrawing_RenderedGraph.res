
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
  border: Element.t,
  label: Element.t,
  lowerLeftLabel: option<Element.t>,
  upperLeftLabel: option<Element.t>,
  upperRightLabel: option<Element.t>,
  lowerRightLabel: option<Element.t>,
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

