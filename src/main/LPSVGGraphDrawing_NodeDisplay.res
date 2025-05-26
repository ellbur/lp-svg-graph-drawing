
module Element = Webapi.Dom.Element

type attachment = {
  relativeX: float,
  relativeY: float,
  dx: float,
  dy: float
}

type attachmentMap = Dict.t<attachment>

type t = {
  g: Element.t,
  width: float,
  height: float,
  relativeCX: float,
  relativeCY: float,
  massWidth: float,
  sourceAttachments: attachmentMap,
  sinkAttachments: attachmentMap
}

