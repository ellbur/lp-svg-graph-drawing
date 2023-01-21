
module Document = Webapi.Dom.Document
module Element = Webapi.Dom.Element

let svgNS = "http://www.w3.org/2000/svg"

let sa = (el, k, v) => v->Belt.Option.forEach(v => el->Element.setAttribute(k, v))
type os = option<string>

let svg = (
  document: Document.t
) => {
  let el = document->Document.createElementNS(svgNS, "svg")
  el
}

let g = (
  document: Document.t,
  ~children: array<Element.t>
) => {
  let el = document->Document.createElementNS(svgNS, "g")
  children->Belt.Array.forEach(child => {
    el->Element.appendChild(~child)
  })
  el
}

let rect = (
  document: Document.t,
  ~rx: os=?,
  ~ry: os=?,
  ~fill: os=?,
  ~strokeWidth: os=?,
  ~class: os=?,
  ~stroke: os=?,
  ()
) => {
  let el = document->Document.createElementNS(svgNS, "rect")
  el->sa("rx", rx)
  el->sa("ry", ry)
  el->sa("fill", fill)
  el->sa("stroke-width", strokeWidth)
  el->sa("class", class)
  el->sa("stroke", stroke)
  el
}

let text = (
  document: Document.t,
  ~textAnchor: os=?,
  ~dominantBaseline: os=?,
  ~fontSize: os=?,
  ~fontFamily: os=?,
  ~class: os=?,
  ~textContent: os=?,
  ()
) => {
  let el = document->Document.createElementNS(svgNS, "text")
  el->sa("text-anchor", textAnchor)
  el->sa("dominant-baseline", dominantBaseline)
  el->sa("font-size", fontSize)
  el->sa("font-family", fontFamily)
  el->sa("class", class)
  textContent->Belt.Option.forEach(el->Element.setTextContent)
  el
}

let path = (
  document: Document.t,
  ~d: os=?,
  ~fill: os=?,
  ~strokeWidth: os=?,
  ~stroke: os=?,
  ~markerEnd: os=?,
  ~class: os=?,
  ()
) => {
  let el = document->Document.createElementNS(svgNS, "path")
  el->sa("d", d)
  el->sa("fill", fill)
  el->sa("stroke-width", strokeWidth)
  el->sa("stroke", stroke)
  el->sa("marker-end", markerEnd)
  el->sa("class", class)
  el
}

let defs = (
  document: Document.t,
  ~children: array<Element.t>
) => {
  let el = document->Document.createElementNS(svgNS, "defs")
  children->Belt.Array.forEach(child => {
    el->Element.appendChild(~child)
  })
  el
}

let marker = (
  document: Document.t,
  ~id: os=?,
  ~viewBox: os=?,
  ~refX: os=?,
  ~refY: os=?,
  ~markerUnits: os=?,
  ~markerWidth: os=?,
  ~markerHeight: os=?,
  ~orient: os=?,
  ~children: array<Element.t>,
  ()
) => {
  let el = document->Document.createElementNS(svgNS, "marker")
  el->sa("id", id)
  el->sa("viewBox", viewBox)
  el->sa("refX", refX)
  el->sa("refY", refY)
  el->sa("markerUnits", markerUnits)
  el->sa("markerWidth", markerWidth)
  el->sa("markerHeight", markerHeight)
  el->sa("orient", orient)
  children->Belt.Array.forEach(child => {
    el->Element.appendChild(~child)
  })
  el
}

