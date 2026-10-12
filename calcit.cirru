
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
            let
                focused-id $ :current-focus store
                focused $ get-in store $ [] :shapes focused-id
              group ({})
                comp-landscape $ :shapes store
                comp-axis
                if (some? focused)
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
              %{} Shape (:p0 p0)
                :p1 $ &v+ p0 $ v-scale rightward 200
                :p2 $ &v+
                  &v+ p0 $ v-scale upward 100
                  v-scale forward 20
                :color-type color-type
                :index $ get-index!
                :id $ %none
                :name $ %none
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Shape)
            :args $ [] 'Number
        'color-types $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def color-types
            []
              {} (:value 0)
                :display $ comp-color-sample 0
              {} (:value 1)
                :display $ comp-color-sample 1
              {} (:value 2)
                :display $ comp-color-sample 2
              {} (:value 3)
                :display $ comp-color-sample 3
              {} (:value 4)
                :display $ comp-color-sample 4
              {} (:value 5)
                :display $ comp-color-sample 5
              {} (:value 6)
                :display $ comp-color-sample 6
              {} (:value 7)
                :display $ comp-color-sample 7
          :examples $ []
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
        'comp-controller $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-controller (store)
            let
                states $ :states store
                cursor $ []
                state $ or (:data states)
                  {} $ :show-list? false
                focused-shape $ if-let
                  focus $ :current-focus store
                  get-in store $ [] :shapes focus
                color-type $ :current-color-type store
                colors-plugin $ use-modal (>> states :colors)
                  {} (:title "|select color type") (:items color-types)
                    :render $ fn (on-close)
                      list->
                        {} $ :style $ merge ui/row-middle
                          {} $ :padding |8px
                        -> color-types $ map $ fn (info)
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
                    :on-result $ fn (v d!)
                      cond
                          = :delete $ :value v
                          d! :delete-shape $ :current-focus store
                        (= :reset-color-type (:value v))
                          d! :reset-color-type nil
              div
                {} $ :class-name $ str-spaced css/global css/row-middle css-controller
                span
                  {} (:class-name css-action) (:style ui/row-middle)
                    :on-click $ fn (e d!) (.show colors-plugin d!)
                  <> |ColorType:
                  comp-color-sample color-type
                span $ {} (:class-name css-action) (:inner-text |List)
                  :on-click $ fn (e d!)
                    d! cursor $ update state :show-list? not
                span $ {} (:class-name css-action) (:inner-text |Add)
                  :on-click $ fn (e d!)
                    d! :new-shape $ assemble-new-shape color-type
                span $ {} (:class-name css-action) (:inner-text |Dupicate)
                  :on-click $ fn (e d!)
                    d! :new-shape $ -> focused-shape (dissoc :id)
                      assoc :index $ get-index!
                span $ {} (:class-name css-action) (:inner-text |color!)
                  :on-click $ fn (e d!) (d! :reset-color-type nil)
                span $ {} (:class-name css-action) (:inner-text |more...)
                  :on-click $ fn (e d!) (.show more-actions-plugin d!)
                .render colors-plugin
                .render more-actions-plugin
                if (:show-list? state)
                  comp-shapes-list (:shapes store) (:current-focus store)
          :examples $ []
        'comp-shapes-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-shapes-list (shapes focused-id)
            list->
              {} $ :class-name css-shapes-list
              ->
                .to-list $ .values shapes
                .sort-by $ fn (shape) (:index shape)
                map $ fn (shape)
                  let
                      shape-id $ :id shape
                    [] shape-id $ div
                      {} (:class-name css-shape)
                        :style $ if (= focused-id shape-id)
                          {} $ :background-color $ hsl 200 0 90
                        :on-click $ fn (e d!) (d! :focus-to shape-id)
                      <> (:index shape)
                        {} (:font-family ui/font-code)
                          :color $ hsl 0 0 60
                      =< 8 nil
                      comp-color-sample $ :color-type shape
          :examples $ []
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
              :background-color $ hsl 0 0 100 $ %some 0.8
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
            case-default i |black (0 |white) (1 |red) (2 |green) (3 |blue) (4 |#ff0) (5 |#f0f) (6 |#0ff)
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
            app.schema :refer $ Shape
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
          :code $ quote $ defatom *store
            {}
              :shapes $ {}
              :states $ {}
              :current-color-type 0
              :current-focus nil
          :examples $ []
        'canvas $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def canvas (js/document.querySelector |canvas)
          :examples $ []
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op data)
            when dev? $ js/console.log |Dispatch: op data
            let
                next $ updater @*store op data (nanoid) (js/Date.now)
              if
                not $ identical? next @*store
                reset! *store next
          :examples $ []
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if dev? $ load-console-formatter!
            twgl/setDefaults $ js-object $ :attribPrefix |a_
            inject-hud!
            reset-canvas-size! canvas
            reset! *gl-context $ .!getContext canvas |webgl $ js-object (:antialias true)
            render-app!
            render-control!
            start-control-loop! 10 on-control-event
            add-watch *store :change $ fn (v _p) (render-app!)
            set! js/window.onresize $ fn (event) (reset-canvas-size! canvas) (render-app!)
            setup-mouse-events! canvas
          :examples $ []
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def mount-target (js/document.querySelector |.controller)
          :examples $ []
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch *store :change) (respo/clear-cache!)
                add-watch *store :change $ fn (v _p) (render-app!)
                replace-control-loop! 10 on-control-event
                set! js/window.onresize $ fn (event) (reset-canvas-size! canvas) (render-app!)
                setup-mouse-events! canvas
                render-app!
                hud! |ok~ |OK
              hud! |error build-errors
          :examples $ []
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            load-objects! (comp-container @*store) dispatch!
            paint-canvas!
            respo/render! mount-target (comp-controller @*store) dispatch!
          :examples $ []
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
            app.updater :refer $ updater
            |nanoid :refer $ nanoid
    'app.schema $ %{} 'FileEntry
      :defs $ {}
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
        'shape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def shape
            %{} Shape
              :p0 $ [] 0 0 0
              :p1 $ [] 0 0 0
              :p2 $ [] 0 0 0
              :color-type 0
              :name $ %some |
              :id $ %none
              :index 0
          :examples $ []
          :schema $ :: 'app.schema/Shape
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op data op-id op-time)
            case-default op
              do (js/console.warn "|unknown op" op) store
              :states $ update-states store data
              :color-type $ assoc store :current-color-type data
              :new-shape $ -> store (assoc :current-focus op-id)
                assoc-in ([] :shapes op-id) (assoc data :id op-id)
              :rename-shape $ let
                  shape-id $ :id data
                  name $ :name data
                assoc-in store ([] :shapes shape-id :name) name
              :move-point $ let
                  shape-id $ :id data
                  position $ :position data
                  point $ :point data
                assoc-in store ([] :shapes shape-id point) position
              :delete-shape $ dissoc-in store $ [] :shapes data
              :reset-color-type $ let
                  shape-id $ :current-focus store
                  color $ :current-color-type store
                assoc-in store ([] :shapes shape-id :color-type) color
              :focus-to $ assoc store :current-focus data
          :examples $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require
            respo.cursor :refer $ update-states
            app.schema :as schema
