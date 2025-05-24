
module Element = Webapi.Dom.Element

type stringMetrics = {
  stringWidth: float,
  stringHeight: float
}
type textSizer = NativeBBox | Calculated((string, ~fontFamily: string, ~fontSize: string) => stringMetrics)

module SVGRect = {
  type t = {
    x: float,
    y: float,
    width: float,
    height: float
  }
}

@send external getBBox: Dom.element => SVGRect.t = "getBBox"

let textElemMetrics = (textSizer, elem, ~fontSize, ~fontFamily) => switch textSizer {
  | NativeBBox =>
      let bbox = elem->getBBox
      {
        stringWidth: bbox.width,
        stringHeight: bbox.height
      }
  | Calculated(f) => f(elem->Element.textContent, ~fontSize, ~fontFamily)
}

