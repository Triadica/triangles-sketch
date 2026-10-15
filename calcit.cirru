
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |touch-control/ |respo.calcit/ |triadica-space/ |respo-ui.calcit/ |alerts.calcit/ |js-ffi/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-container (store)
            group ({})
              comp-landscape $ :shapes store
              comp-axis
              match (focused-shape store)
                (:none)
                  group $ {}
                (:some focused)
                  let
                      focused-id $ .unwrap $ :current-focus store
                    group ({})
                      comp-drag-point
                        {} $ :position $ :p0 focused
                        fn (p d!)
                          d! :move-point $ {} (:id focused-id) (:point :p0) (:position p)
                      comp-drag-point
                        {} $ :position $ :p1 focused
                        fn (p d!)
                          d! :move-point $ {} (:id focused-id) (:point :p1) (:position p)
                      comp-drag-point
                        {} $ :position $ :p2 focused
                        fn (p d!)
                          d! :move-point $ {} (:id focused-id) (:point :p2) (:position p)
                      comp-hint-line focused
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/Store
            :features $ #{} :js-ffi
            :return $ :: 'Map 'Tag 'Dynamic
        'comp-hint-line $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-hint-line (shape)
            object $ {} (:draw-mode :line-loop)
              :vertex-shader $ inline-shader |line.vert
              :fragment-shader $ inline-shader |line.frag
              :points $ []
                &v+ (:p0 shape) ([] 0 2 0)
                &v+ (:p1 shape) ([] 0 2 0)
                &v+ (:p2 shape) ([] 0 2 0)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/Shape
            :return $ :: 'Map 'Tag 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            app.config :refer $ inline-shader
            triadica.alias :refer $ object group
            triadica.comp.axis :refer $ comp-axis
            app.comp.landscape :refer $ comp-landscape
            triadica.comp.drag-point :refer $ comp-drag-point
            triadica.vector :refer $ &v+
            app.updater :refer $ focused-shape
    'app.comp.controller $ %{} 'FileEntry
      :defs $ {}
        '*index-cache $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *index-cache 0
          :examples $ []
          :schema $ :: 'Ref 'Number
        'actions $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def actions
            [] $ {} (:value :delete) (:display |DELETE)
          :examples $ []
        'assemble-new-shape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn assemble-new-shape (color-type)
            let
                viewer @perspective/*viewer-position
                forward @perspective/*viewer-forward
                upward @perspective/*viewer-upward
                rightward $ v-cross forward upward
                p0 $ &v+ viewer $ v-scale forward 200
              Shape :p0 p0 :p1
                &v+ p0 $ v-scale rightward 200
                , :p2
                  &v+
                    &v+ p0 $ v-scale upward 100
                    v-scale forward 20
                  , :color-type color-type :index (get-index!) :id (Option :none) :name $ Option :none
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Shape)
            :args $ [] 'Number
        'color-types $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def color-types
            []
              ColorChoice :value 0 :display $ comp-color-sample 0
              ColorChoice :value 1 :display $ comp-color-sample 1
              ColorChoice :value 2 :display $ comp-color-sample 2
              ColorChoice :value 3 :display $ comp-color-sample 3
              ColorChoice :value 4 :display $ comp-color-sample 4
              ColorChoice :value 5 :display $ comp-color-sample 5
              ColorChoice :value 6 :display $ comp-color-sample 6
              ColorChoice :value 7 :display $ comp-color-sample 7
          :examples $ []
          :schema $ :: 'List 'app.schema/ColorChoice
        'comp-color-sample $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-color-sample (i)
            div
              {} (:class-name css-color-sample)
                :style $ {}
                  :background-color $ index->color i
                  :margin "|4px 8px"
              <> (str i)
                {} (:font-family ui/font-code) (:opacity 0.8)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'Number
        'comp-controller $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-controller (store)
            let
                states $ :states store
                cursor $ []
                raw-state $ .unwrap-or (get states :data) nil
                state $ if (nil? raw-state)
                  {} $ :show-list? false
                  decode-map-as raw-state $ :: 'Map 'Tag 'Bool
                show-list? $ .unwrap-or (get state :show-list?) false
                focused $ focused-shape store
                color-type $ :current-color-type store
                colors-plugin $ use-modal (>> states :colors)
                  {} (:title "|select color type")
                    :render $ fn (on-close)
                      list->
                        {} $ :style $ merge ui/row-middle
                          {} $ :padding |8px
                        map color-types $ fn (info)
                          [] (:value info)
                            div
                              {}
                                :style $ {} $ :cursor :pointer
                                :on-click $ fn (e d!)
                                  d! :color-type $ :value info
                                  on-close d!
                              :display info
                more-actions-plugin $ use-modal-menu (>> states :more)
                  {} (:title |actions) (:items actions)
                    :on-result $ fn (result d!)
                      if (nil? result) &unit $ match result
                        (:item value label)
                          match (decode-map-as value 'Tag)
                            :delete $ match (:current-focus store)
                              (:none) &unit
                              (:some id) (d! :delete-shape id)
                            :reset-color-type $ d! :reset-color-type nil
                            _ &unit
                        _ $ raise |expected-modal-menu-item
              div
                {} $ :class-name $ str-spaced css/global css/row-middle css-controller
                span
                  {} (:class-name css-action) (:style ui/row-middle)
                    :on-click $ fn (e d!) (.show colors-plugin d!)
                  <> |ColorType:
                  comp-color-sample color-type
                span $ {} (:class-name css-action) (:inner-text |List)
                  :on-click $ fn (e d!)
                    d! cursor $ assoc state :show-list? $ not show-list?
                span $ {} (:class-name css-action) (:inner-text |Add)
                  :on-click $ fn (e d!)
                    d! :new-shape $ .to-map $ assemble-new-shape color-type
                span $ {} (:class-name css-action) (:inner-text |Duplicate)
                  :on-click $ fn (e d!)
                    match focused
                      (:none) &unit
                      (:some shape)
                        d! :new-shape $ .to-map $ assoc shape :index (get-index!)
                span $ {} (:class-name css-action) (:inner-text |color!)
                  :on-click $ fn (e d!) (d! :reset-color-type nil)
                span $ {} (:class-name css-action) (:inner-text |more...)
                  :on-click $ fn (e d!) (.show more-actions-plugin d!)
                .render colors-plugin
                .render more-actions-plugin
                if show-list? $ comp-shapes-list (:shapes store) (:current-focus store)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/Store
        'comp-shapes-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-shapes-list (shapes focused-id)
            list->
              {} $ :class-name css-shapes-list
              ->
                .to-list $ .distinct-values shapes
                .sort-by $ fn (shape)
                  hint-fn $ {}
                    :args $ [] 'app.schema/Shape
                    :return 'Number
                  :index shape
                map $ fn (shape)
                  let
                      shape-id $ .unwrap $ :id shape
                      focused? $ match focused-id
                        (:none) false
                        (:some id) (= id shape-id)
                    [] shape-id $ div
                      {} (:class-name css-shape)
                        :style $ if focused?
                          {} $ :background-color $ hsl 200 0 90
                          {}
                        :on-click $ fn (e d!) (d! :focus-to shape-id)
                      <>
                        str $ :index shape
                        {} (:font-family ui/font-code)
                          :color $ hsl 0 0 60
                      =< 8 nil
                      comp-color-sample $ :color-type shape
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] (:: 'Map 'String 'app.schema/Shape) (:: 'Option 'String)
        'css-action $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-action
            {} $ |$0 $ {} (:margin "|0 8px") (:cursor :pointer) (:user-select :none)
          :examples $ []
        'css-color-sample $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-color-sample
            {} $ |$0 $ merge ui/center
              {} (:width 20) (:height 20) (:border-radius |4px) (:color :white)
                :border $ str "|1px solid " $ hsl 0 0 90
                :font-size 10
                :text-shadow $ str "|0 0 2px black"
          :examples $ []
        'css-controller $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-controller
            {} $ |$0 $ {} (:position :absolute) (:top 4) (:left 0) (:color :white) (:padding "|4px 12px")
          :examples $ []
        'css-shape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-shape
            {} $ |$0 $ merge ui/row-middle
              {} (:color :black) (:line-height |24px) (:padding "|4px 8px") (:cursor :pointer)
          :examples $ []
        'css-shapes-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-shapes-list
            {} $ |$0 $ {} (:position :fixed) (:z-index 1001) (:top 44) (:left 120) (:min-width 40) (:max-height |84vh) (:padding "|8px 0") (:border-radius |4px) (:z-index 80) (:overflow :auto) (:padding-bottom 100) (:line-height |20px)
              :background-color $ hsl 0 0 100 $ Option :some 0.8
          :examples $ []
        'get-index! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-index! ()
            let
                v @*index-cache
              swap! *index-cache inc
              , v
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
        'index->color $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn index->color (i)
            match i (0 |white) (1 |red) (2 |green) (3 |blue) (4 |#ff0) (5 |#f0f) (6 |#0ff) (_ |black)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.controller
          :require (respo-ui.core :as ui)
            respo-ui.core :refer $ hsl
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input list->
            respo.comp.space :refer $ =<
            respo.css :refer $ defstyle
            respo-ui.css :as css
            respo-alerts.core :refer $ use-modal-menu use-modal
            triadica.perspective :as perspective
            triadica.vector :refer $ v-cross v-scale &v+
            app.schema :refer $ Shape ColorChoice
            app.updater :refer $ focused-shape
    'app.comp.landscape $ %{} 'FileEntry
      :defs $ {}
        'comp-landscape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-landscape (shapes)
            if (empty? shapes)
              group $ {}
              let
                  shape-list $ .to-list $ .distinct-values shapes
                object $ {} (:draw-mode :triangles)
                  :vertex-shader $ inline-shader |shape.vert
                  :fragment-shader $ inline-shader |shape.frag
                  :points $ landscape-vertices shape-list
                  :attributes $ {} $ :color_index (landscape-colors shape-list)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] $ :: 'Map 'String 'app.schema/Shape
            :return $ :: 'Map 'Tag 'Dynamic
        'landscape-colors $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn landscape-colors (shape-list)
            concat & $ map shape-list $ fn (shape)
              repeat (:color-type shape) 3
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] $ :: 'List 'app.schema/Shape
            :return $ :: 'List 'Number
        'landscape-vertices $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn landscape-vertices (shape-list)
            concat & $ map shape-list shape-vertices
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] $ :: 'List 'app.schema/Shape
            :return $ :: 'List $ :: 'List 'Number
        'shape-vertices $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn shape-vertices (shape)
            [] (:p0 shape) (:p1 shape) (:p2 shape)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/Shape
            :return $ :: 'List $ :: 'List 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.landscape
          :require
            app.config :refer $ inline-shader
            triadica.alias :refer $ object group
    'app.config $ %{} 'FileEntry
      :defs $ {} $ 'inline-shader
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defmacro inline-shader (file) (println "|inline shader file:" file)
            read-file $ str |shaders/ file
          :examples $ []
          :schema $ :: 'Macro $ {}
            :capabilities $ #{} :fs-read :log
            :expansion $ :: 'Expr 'String
            :required $ [] 'Syntax
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *store schema/store
          :examples $ []
          :schema $ :: 'Ref 'app.schema/Store
        'CanvasHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait CanvasHost
            .get-context $ :: 'Fn $ {}
              :args $ [] 'app.main/CanvasHost 'String 'JsObject
              :return $ :: 'JsNullish 'JsObject
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ :: 'Trait
        'canvas $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def canvas
            .unwrap $ query-selector |canvas
          :examples $ []
          :schema $ :: 'js-ffi.browser/DomElementHost
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op data)
            when dev? $ js/console.log |Dispatch: op data
            let
                op-id $ expect-string |nanoid $ nanoid
                op-time $ expect-number |Date.now $ js/Date.now
                next $ if (list? op)
                  update-cursor @*store
                    decode-map-as op $ :: 'List 'Tag
                    , data
                  updater @*store (decode-map-as op 'Tag) data op-id op-time
              when
                not $ identical? next @*store
                reset! *store next
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic 'Dynamic
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if dev? $ load-console-formatter!
            twgl/setDefaults $ &js-object :attribPrefix |a_
            inject-hud!
            reset-canvas-size! canvas
            let
                host $ js-cast canvas 'app.main/CanvasHost
                context $ host .get-context |webgl $ &js-object :antialias true
              if (js-present? context)
                reset! *gl-context $ Option :some context
                raise |WebGL-context-unavailable
            render-app!
            render-control!
            start-control-loop! 10 on-control-event
            add-watch! *store :change $ fn (v _p) (render-app!)
            set! js/window.onresize $ fn (event) (reset-canvas-size! canvas) (render-app!)
            setup-mouse-events! canvas
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target (query-mount-target)
          :examples $ []
          :schema $ :: 'JsNullish 'respo.dom/DomElement
        'query-mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn query-mount-target ()
            let
                document $ js-cast js/document 'respo.dom/DomDocument
              document .query-selector |.controller
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'JsNullish 'respo.dom/DomElement
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch! *store :change) (respo/clear-cache!)
                add-watch! *store :change $ fn (v _p) (render-app!)
                replace-control-loop! 10 on-control-event
                set! js/window.onresize $ fn (event) (reset-canvas-size! canvas) (render-app!)
                setup-mouse-events! canvas
                render-app!
                hud! |ok~ |OK
              hud! |error build-errors
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            load-objects! (comp-container @*store) dispatch!
            paint-canvas!
            respo/render! mount-target (comp-controller @*store)
              fn (action)
                let
                    operation $ respo-operation action
                  dispatch!
                    .unwrap $ get operation 0
                    .unwrap $ get operation 1
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require (|./calcit.build-errors :default build-errors) (|bottom-tip :default hud!)
            triadica.config :refer $ dev? dpr
            |twgl.js :as twgl
            respo.core :as respo
            touch-control.core :refer $ render-control! start-control-loop! replace-control-loop!
            triadica.core :refer $ handle-key-event on-control-event load-objects! paint-canvas! handle-screen-click! setup-mouse-events! reset-canvas-size!
            triadica.global :refer $ *gl-context *uniform-data
            triadica.hud :refer $ inject-hud!
            app.comp.container :refer $ comp-container
            app.comp.controller :refer $ comp-controller
            triadica.alias :refer $ group
            app.schema :as schema
            app.updater :refer $ updater update-cursor respo-operation
            |nanoid :refer $ nanoid
            js-ffi.contract :refer $ expect-string expect-number
            js-ffi.browser :refer $ query-selector
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'ColorChoice $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct ColorChoice (:value 'Number) (:display 'respo.schema/Component)
          :examples $ []
          :schema $ :: 'StructDef
        'MovePoint $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct MovePoint (:id 'String) (:point 'Tag)
            :position $ :: 'List 'Number
          :examples $ []
          :schema $ :: 'StructDef
        'RenameShape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct RenameShape (:id 'String) (:name 'String)
          :examples $ []
          :schema $ :: 'StructDef
        'Shape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Shape
            :p0 $ :: 'List 'Number
            :p1 $ :: 'List 'Number
            :p2 $ :: 'List 'Number
            :color-type 'Number
            :name $ :: 'Option 'String
            :id $ :: 'Option 'String
            :index 'Number
          :examples $ []
          :schema $ :: 'StructDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :shapes $ :: 'Map 'String 'app.schema/Shape
            :states $ :: 'Map 'Tag 'Dynamic
            :current-color-type 'Number
            :current-focus $ :: 'Option 'String
          :examples $ []
          :schema $ :: 'StructDef
        'shape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def shape
            Shape :p0 ([] 0 0 0) :p1 ([] 0 0 0) :p2 ([] 0 0 0) :color-type 0 :name (Option :some |) :id (Option :none) :index 0
          :examples $ []
          :schema $ :: 'app.schema/Shape
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :shapes ({}) :states ({}) :current-color-type 0 :current-focus $ Option :none
          :examples $ []
          :schema $ :: 'app.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {}
        'focused-shape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn focused-shape (store)
            match (:current-focus store)
              (:none) (Option :none)
              (:some id)
                get (:shapes store) id
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/Store
            :return $ :: 'Option 'app.schema/Shape
        'respo-operation $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn respo-operation (action)
            if (enum? action)
              match action
                (:states cursor state)
                  []
                    decode-map-as cursor $ :: 'List 'Tag
                    , state
                _ $ []
                  decode-map-as
                    .unwrap $ get action 0
                    , 'Tag
                  .unwrap-or (get action 1) nil
              raise |expected-respo-action-enum
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :return $ :: 'List 'Dynamic
        'update-cursor $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-cursor (store cursor data)
            assoc store :states $ decode-map-as
              update-state-tree (:states store) cursor data
              :: 'Map 'Tag 'Dynamic
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store (:: 'List 'Tag) 'Dynamic
            :features $ #{} :js-ffi
        'updater $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op data op-id op-time)
            match op
              :color-type $ assoc store :current-color-type $ decode-map-as data 'Number
              :new-shape $ let
                  shape $ assoc (decode-map-as data schema/Shape) :id $ Option :some op-id
                -> store
                  assoc :current-focus $ Option :some op-id
                  assoc :shapes $ assoc (:shapes store) op-id shape
              :rename-shape $ let
                  change $ decode-map-as data schema/RenameShape
                  shapes $ :shapes store
                  id $ :id change
                  shape $ .unwrap $ get shapes id
                assoc store :shapes $ assoc shapes id $ assoc shape :name
                  Option :some $ :name change
              :move-point $ let
                  change $ decode-map-as data schema/MovePoint
                  shapes $ :shapes store
                  id $ :id change
                  shape $ .unwrap $ get shapes id
                  position $ :position change
                  next $ match (:point change)
                    :p0 $ assoc shape :p0 position
                    :p1 $ assoc shape :p1 position
                    :p2 $ assoc shape :p2 position
                    _ $ raise |unknown-shape-point
                assoc store :shapes $ assoc shapes id next
              :delete-shape $ assoc store :shapes $ dissoc (:shapes store) (decode-map-as data 'String)
              :reset-color-type $ match (focused-shape store)
                (:none) store
                (:some shape)
                  let
                      id $ .unwrap $ :id shape
                    assoc store :shapes $ assoc (:shapes store) id $ assoc shape :color-type (:current-color-type store)
              :focus-to $ assoc store :current-focus $ Option :some (decode-map-as data 'String)
              _ $ do (js/console.warn "|unknown op" op) store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'Tag 'Dynamic 'String 'Number
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require
            respo.cursor :refer $ update-state-tree
            app.schema :as schema
