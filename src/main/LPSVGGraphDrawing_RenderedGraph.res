
module Element = Webapi.Dom.Element

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
}

type renderedEdge = {
  path: Element.t,
  sinkLabel: Element.t,
}

type t = {
  nodes: Js.Dict.t<renderedNode>,
  edges: Js.Dict.t<renderedEdge>,
  layout: LPLayout.layout,
}

