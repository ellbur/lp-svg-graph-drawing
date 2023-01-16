
Js.Console.log("PostReifyTest")

module SVGRect = {
  type t = {
    x: float,
    y: float,
    width: float,
    height: float
  }
}

@send external getBBox: Dom.element => SVGRect.t = "getBBox"

module Panel = {
  @react.component
  let make = (~labels) => {
    let textRefs = Js.Dict.empty()
    
    let onRender = _ => {
      Js.Console.log2("onRender", textRefs)
      let spacing = 10.0
      let workingX = ref(spacing)
      labels->Belt.Array.forEach(label => {
        let elem = (textRefs->Js.Dict.unsafeGet(label)).React.current->Js.Nullable.toOption->Belt.Option.getUnsafe
        elem->Webapi.Dom.Element.setAttribute("x", workingX.contents->Belt.Float.toString)
        let width = (elem->getBBox).SVGRect.width
        workingX.contents = workingX.contents +. width +. spacing
      })
    }
    
    <svg ref={ReactDOM.Ref.callbackDomRef(onRender)} width="500" height="500">
      <circle cx="250" cy="250" r="30" fill="#333" stroke="none"/>
      {
        React.array(labels->Belt.Array.map(label => {
          let textRef = React.useRef(Js.Nullable.null)
          textRefs->Js.Dict.set(label, textRef)
          <text key={label} ref={ReactDOM.Ref.domRef(textRef)} x="100" y="100" fontFamily="monospace" fontSize="16" fill="#999" stroke="none">{React.string(label)}</text>
        }))
      }
    </svg>
  }
}

let container = ReactDOM.querySelector("#root")->Belt.Option.getExn
let root = ReactDOM.Client.createRoot(container)
root->ReactDOM.Client.Root.render(<Panel labels={["alice", "bob", "carol", "denise"]}/>)

