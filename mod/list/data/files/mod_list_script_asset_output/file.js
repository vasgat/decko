// pointer_config.js.coffee
(function(){var t,n;$.extend(decko.editorContentFunctionMap,{"select.pointer-select":function(){return n(this.val())},"select.pointer-multiselect":function(){return n(this.val())},".pointer-radio-list":function(){return n(this.find("input:checked").val())},".pointer-list-ul":function(){return n(this.find("input").map(function(){return $(this).val()}))},".pointer-link-list-ul":function(){return decko.linkListContent(this.find(".input-group"))},"._nest-list-ul":function(){return decko.nestListContent(this.find(".input-group"))},".pointer-checkbox-list":function(){return n(this.find("input:checked").map(function(){return $(this).val()}))},".pointer-select-list":function(){return n(this.find(".pointer-select select").map(function(){return $(this).val()}))},"._filtered-list":function(){return n(this.find("._filtered-list-item").map(function(){return $(this).data("cardName")}))},"._pointer-list":function(){return n(this.find("._pointer-item").map(function(){return $(this).val()}))},"._click-select-editor":function(){return n(this.find("._select-item.selected").map(function(){return $($(this).find("[data-card-name]")[0]).data("cardName")}))},"._click-multiselect-editor":function(){return n(this.find("._select-item.selected").map(function(){return $($(this).find("[data-card-name]")[0]).data("cardName")}))},".perm-editor":function(){return t(this)}}),decko.editorInitFunctionMap[".pointer-list-editor"]=function(){return this.sortable({handle:".handle",cancel:""}),decko.initPointerList(this.find("input"))},decko.editorInitFunctionMap["._filtered-list"]=function(){return this.sortable({handle:"._handle",cancel:""})},$.extend(decko,{initPointerList:function(t){return decko.initAutoCardPlete(t)},pointerContent:function(t){return $.makeArray(t).join("\n")},linkListContent:function(t){var n,i;return i=t.map(function(){var t,n;return n=$(this).find("input._reference").val(),(t=$(this).find("input._title").val()).length>0&&(n+="|"+t),n}),n=$.map($.makeArray(i),function(t){if(t)return"[["+t+"]]"}),$.makeArray(n).join("\n")},nestListContent:function(t){var n,i;return i=t.map(function(){var t,n;return n=$(this).find("input._reference").val(),(t=$(this).find("input._nest-options").val()).length>0&&(n+="|"+t),n}),n=$.map($.makeArray(i),function(t){if(t)return"{{"+t+"}}"}),$.makeArray(n).join("\n")}}),n=function(t){return decko.pointerContent(t)},t=function(t){var i,e;return t.find("#inherit").is(":checked")?"_left":(i=t.find(".perm-group input:checked").map(function(){return $(this).val()}),e=t.find(".perm-indiv input").map(function(){return $(this).val()}),n($.makeArray(i).concat($.makeArray(e))))}}).call(this);
// pointer_list_editor.js.coffee
(function(){$(window).ready(function(){return $("body").on("click","._pointer-item-add",function(t){return decko.addPointerItem(this),t.preventDefault()}),$("body").on("keydown",".pointer-item-text",function(t){if("Enter"===t.key)return decko.addPointerItem(this),t.preventDefault()}),$("body").on("keyup",".pointer-item-text",function(){return decko.updateAddItemButton(this)}),$("body").on("click",".pointer-item-delete",function(){var t,e;return(e=(t=$(this).closest("li")).closest("ul")).find(".pointer-li").length>1?t.remove():t.find("input").val(""),decko.updateAddItemButton(e)})}),decko.slotReady(function(t){return t.find(".pointer-list-editor").each(function(){return decko.updateAddItemButton(this)})}),$.extend(decko,{addPointerItem:function(t){var e,n;return(n=$(t).slot()).trigger("slotDestroy"),(e=decko.nextPointerInput(decko.lastPointerItem(t))).val(""),n.trigger("slotReady"),decko.initializeEditors(n),e.first().focus(),decko.updateAddItemButton(t),decko.initPointerList(e)},nextPointerInput:function(t){var e,n,i,o,d,r;for(e=!0,n=0,d=(o=t.find("input")).length;n<d;n++)i=o[n],e=e&&""===$(i).val();return e?o:(r=t.clone(),t.after(r),r.attr("data-index",parseInt(t.attr("data-index")+1)),r.find("input"))},lastPointerItem:function(t){return $(t).closest(".content-editor").find(".pointer-li:last")},updateAddItemButton:function(t){var e,n;return e=$(t).closest(".content-editor").find("._pointer-item-add"),n=""===decko.lastPointerItem(t).find("input").val(),e.prop("disabled",n)}})}).call(this);