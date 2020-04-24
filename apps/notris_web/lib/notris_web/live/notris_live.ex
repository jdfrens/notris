defmodule NotrisWeb.NotrisLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <?xml version="1.0" encoding="iso-8859-1"?>
      <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 496 496" style="enable-background:new 0 0 496 496;" xml:space="preserve">
        <!-- red three? I -->
        <rect x="200" style="fill:#CE351B;" width="64" height="64"/>
        <polyline style="fill:#A50C00;" points="200,0 264,0 264,56 "/>
        <rect x="272" style="fill:#CE351B;" width="64" height="64"/>
        <polyline style="fill:#A50C00;" points="272,0 336,0 336,64 "/>
        <rect x="344" style="fill:#CE351B;" width="64" height="64"/>
        <polyline style="fill:#A50C00;" points="344,0 408,0 408,64 "/>

        <!-- blue T -->
        <rect x="344" y="128" style="fill:#049CBF;" width="64" height="64"/>
        <polyline style="fill:#047BA0;" points="408,128 408,192 344,192 "/>
        <rect x="344" y="200" style="fill:#049CBF;" width="64" height="64"/>
        <polyline style="fill:#047BA0;" points="408,200 408,264 344,264 "/>
        <rect x="272" y="200" style="fill:#049CBF;" width="64" height="64"/>
        <polyline style="fill:#047BA0;" points="336,200 336,264 272,264 "/>
        <rect x="344" y="272" style="fill:#049CBF;" width="64" height="64"/>
        <polyline style="fill:#047BA0;" points="408,272 408,336 344,336 "/>

        <!-- green L -->
        <rect x="88" style="fill:#34B515;" width="64" height="64"/>
        <polyline style="fill:#129B0B;" points="152,0 152,64 88,64 "/>
        <rect x="88" y="72" style="fill:#34B515;" width="64" height="64"/>
        <polyline style="fill:#129B0B;" points="152,72 152,136 88,136 "/>
        <rect x="88" y="144" style="fill:#34B515;" width="64" height="64"/>
        <polyline style="fill:#129B0B;" points="152,144 152,208 88,208 "/>
        <rect x="160" y="144" style="fill:#34B515;" width="64" height="64"/>
        <polyline style="fill:#129B0B;" points="224,144 224,208 160,208 "/>

        <!-- orange ? -->
        <rect x="160" y="336" style="fill:#D66203;" width="64" height="64"/>
        <polyline style="fill:#EF880C;" points="160,400 160,336 224,336 "/>
        <rect x="160" y="264" style="fill:#D66203;" width="64" height="64"/>
        <polyline style="fill:#EF880C;" points="160,328 160,264 224,264 "/>
        <rect x="88" y="264" style="fill:#D66203;" width="64" height="64"/>
        <polyline style="fill:#EF880C;" points="88,328 88,264 152,264 "/>

        <!- purple -->
        <rect x="272" y="432" style="fill:#835EA5;" width="64" height="64"/>
        <polyline style="fill:#683C96;" points="336,432 336,496 272,496 "/>
        <rect x="344" y="432" style="fill:#835EA5;" width="64" height="64"/>
        <polyline style="fill:#683C96;" points="408,432 408,496 344,496 "/>
        <rect x="272" y="360" style="fill:#835EA5;" width="64" height="64"/>
        <polyline style="fill:#683C96;" points="336,360 336,424 272,424 "/>
        <rect x="344" y="360" style="fill:#835EA5;" width="64" height="64"/>
        <polyline style="fill:#683C96;" points="408,360 408,424 344,424 "/>

        <rect x="256" y="104" style="fill:#353A3A;" width="64" height="64"/>
        <polyline style="fill:#1E2323;" points="320,104 320,168 256,168 "/>
      </svg>

    </div>
    """
  end
end
