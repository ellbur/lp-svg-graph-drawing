
type annotations = {
  lowerLeft?: string,
  upperLeft?: string,
  lowerRight?: string,
  upperRight?: string,
}

type attachment = {
  relativeHorizontalFraction: float
}

type style = {
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

type options = {
  text: string,
  sourceAttachments: Js.Dict.t<attachment>,
  sinkAttachments: Js.Dict.t<attachment>,
  annotations: annotations,
  orientation: LPLayout.orientation,
  style: style
}

module NodeDisplay = LPSVGGraphDrawing_NodeDisplay
type display = NodeDisplay.t

module Document = Webapi.Dom.Document
module Element = Webapi.Dom.Element

type textSizer = LPSVGGraphDrawing_StringMetrics.textSizer
let textElemMetrics = LPSVGGraphDrawing_StringMetrics.textElemMetrics

let fts = Belt.Float.toString

let todo = LPSVGGraphDrawing_Utils.todo

let make = (document: Document.t, mainG: Element.t, textSizer: textSizer, options: options): display => {
  let {rect, text, g} = module(LPSVGGraphDrawing_SVGUtils)

  let {
    text: label,
    sourceAttachments,
    sinkAttachments,
    annotations,
    orientation,
    style: {
      nodeBorderStrokeWidth,
      nodeHorizontalPadding,
      nodeVerticalPadding,
      nodeFontSize,
      nodeFontFamily,
      nodeSideTextFontSize,
      nodeSideTextFontFamily,
      nodeSideTextXOffset,
      nodeRoundingX,
      nodeRoundingY,
    }
  } = options

  let rectElem = document->rect(
    ~rx=nodeRoundingX->Belt.Float.toString,
    ~ry=nodeRoundingY->Belt.Float.toString,
    ~fill="none",
    ~strokeWidth=nodeBorderStrokeWidth,
    ~class="node-border",
    ~stroke="#999",
    ()
  )
  
  let textElem = document->text(
    ~textAnchor="middle",
    ~dominantBaseline="middle",
    ~fontSize=nodeFontSize,
    ~fontFamily=nodeFontFamily,
    ~class="node-text",
    ~textContent=label,
    ()
  )
  
  let lowerLeftElem: option<Element.t> = annotations.lowerLeft->Belt.Option.map(textContent => document->text(
    ~textAnchor="end",
    ~dominantBaseline="auto",
    ~fontSize=nodeSideTextFontSize,
    ~fontFamily=nodeSideTextFontFamily,
    ~class="node-annotation node-annotation-lower-left",
    ~textContent,
    ()
  ))

  let upperLeftElem: option<Element.t> = annotations.upperLeft->Belt.Option.map(textContent => document->text(
    ~textAnchor="end",
    ~dominantBaseline="hanging",
    ~fontSize=nodeSideTextFontSize,
    ~fontFamily=nodeSideTextFontFamily,
    ~class="node-annotation node-annotation-upper-left",
    ~textContent,
    ()
  ))

  let lowerRightElem: option<Element.t> = annotations.lowerRight->Belt.Option.map(textContent => document->text(
    ~textAnchor="start",
    ~dominantBaseline="auto",
    ~fontSize=nodeSideTextFontSize,
    ~fontFamily=nodeSideTextFontFamily,
    ~class="node-annotation node-annotation-lower-right",
    ~textContent,
    ()
  ))

  let upperRightElem: option<Element.t> = annotations.upperRight->Belt.Option.map(textContent => document->text(
    ~textAnchor="start",
    ~dominantBaseline="hanging",
    ~fontSize=nodeSideTextFontSize,
    ~fontFamily=nodeSideTextFontFamily,
    ~class="node-annotation node-annotation-upper-right",
    ~textContent,
    ()
  ))
  
  let nodeChildren = [Some(rectElem), Some(textElem), lowerLeftElem, upperLeftElem, lowerRightElem, upperRightElem]->Belt.Array.flatMap(el =>
    el->Belt.Option.mapWithDefault([], x => [x])
  )
  
  let nodeG = document->g(~children=nodeChildren)
  mainG->Element.appendChild(~child=nodeG)
  
  let leftAnnotationSize = [lowerLeftElem, upperLeftElem]->Belt.Array.map(el => el->Belt.Option.mapWithDefault(0.0, el => {
    let {stringWidth: width} = textElemMetrics(textSizer, el, ~fontSize=nodeSideTextFontSize, ~fontFamily=nodeSideTextFontFamily)
    width +. nodeSideTextXOffset
  }))->Belt.Array.reduce(0.0, Js.Math.max_float)
  
  let rightAnnotationSize = [lowerRightElem, upperRightElem]->Belt.Array.map(el => el->Belt.Option.mapWithDefault(0.0, el => {
    let {stringWidth: width} = textElemMetrics(textSizer, el, ~fontSize=nodeSideTextFontSize, ~fontFamily=nodeSideTextFontFamily)
    width +. nodeSideTextXOffset
  }))->Belt.Array.reduce(0.0, Js.Math.max_float)
  
  let {stringWidth: textWidth, stringHeight: textHeight} = textElemMetrics(textSizer, textElem, ~fontSize=nodeFontSize, ~fontFamily=nodeFontFamily)
  let rectWidth = textWidth +. 2.0*.nodeHorizontalPadding
  let rectHeight = textHeight +. 2.0*.nodeVerticalPadding
  
  rectElem->Element.setAttribute("x", fts(leftAnnotationSize))
  rectElem->Element.setAttribute("y", "0")
  rectElem->Element.setAttribute("width", fts(rectWidth))
  rectElem->Element.setAttribute("height", fts(rectHeight))
  
  textElem->Element.setAttribute("x", fts(leftAnnotationSize +. rectWidth/.2.0))
  textElem->Element.setAttribute("y", fts(rectHeight/.2.0))
  
  lowerLeftElem->Belt.Option.forEach(el => el->Element.setAttribute("x", fts(leftAnnotationSize-.nodeSideTextXOffset)))
  lowerLeftElem->Belt.Option.forEach(el => el->Element.setAttribute("y", fts(rectHeight -. 0.5*.nodeRoundingY)))
  
  upperLeftElem->Belt.Option.forEach(el => el->Element.setAttribute("x", fts(leftAnnotationSize-.nodeSideTextXOffset)))
  upperLeftElem->Belt.Option.forEach(el => el->Element.setAttribute("y", "0.0"))
  
  lowerRightElem->Belt.Option.forEach(el => el->Element.setAttribute("x", fts(leftAnnotationSize+.rectWidth+.nodeSideTextXOffset)))
  lowerRightElem->Belt.Option.forEach(el => el->Element.setAttribute("y", fts(rectHeight -. 0.5*.nodeRoundingY)))
  
  upperRightElem->Belt.Option.forEach(el => el->Element.setAttribute("x", fts(leftAnnotationSize+.rectWidth+.nodeSideTextXOffset)))
  upperRightElem->Belt.Option.forEach(el => el->Element.setAttribute("y", "0.0"))
  
  let flatWidth = rectWidth -. 2.0*.nodeRoundingX

  let width = leftAnnotationSize +. rectWidth +. rightAnnotationSize
  let height = rectHeight
  let relativeCX = leftAnnotationSize +. rectWidth/.2.0
  let relativeCY = rectHeight/.2.0
  let sourceAttachments: NodeDisplay.attachmentMap = sourceAttachments->Dict.mapValues(({relativeHorizontalFraction}): NodeDisplay.attachment =>
    {
      relativeX: leftAnnotationSize +. nodeRoundingX +. relativeHorizontalFraction *. flatWidth,
      relativeY: 0.0,
      dx: 0.0,
      dy: switch orientation {
        | FlowingUp => -1.0
        | FlowingDown => 1.0
      }
    }
  )
  let sinkAttachments: NodeDisplay.attachmentMap = sinkAttachments->Dict.mapValues(({relativeHorizontalFraction}): NodeDisplay.attachment =>
    {
      relativeX: leftAnnotationSize +. nodeRoundingX +. relativeHorizontalFraction *. flatWidth,
      relativeY: height,
      dx: 0.0,
      dy: switch orientation {
        | FlowingUp => 1.0
        | FlowingDown => -1.0
      }
    }
  )

  {
    g: nodeG,
    width,
    height,
    relativeCX,
    relativeCY,
    sourceAttachments,
    sinkAttachments
  }
}

