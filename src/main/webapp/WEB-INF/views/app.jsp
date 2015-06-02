<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page session="false"%>
<html>
  <head>
	  <script src="http://maps.googleapis.com/maps/api/js?sensor=false" type="text/javascript"></script>
	  <script type="text/javascript" src="<c:url value="/resources/dist/jquery.js"/>"></script>
	  <script type="text/javascript" src="<c:url value="/resources/dist/gmap3.js"/>"></script>
	  <script type="text/javascript" src="<c:url value="/resources/menu/gmap3-menu.js"/>"></script>
	  <link rel="stylesheet" type="text/css" href="<c:url value="/resources/menu/gmap3-menu.css"/>" />
	 
    <style>
      #container{
        position:relative;
        height:700px;
      }
      #directions{
        position:absolute;
        width: 23%;
        right:1%;
        height: 690px;
        overflow:auto;
      }
      #googleMap{
        border: 1px dashed #C0C0C0;
        width: 75%;
        height: 700px;
      }
    </style>

    <script type="text/javascript">
      $(function(){

        var $map = $("#googleMap"),
          menu = new Gmap3Menu($map),
          current,  // current click event (used to save as start / end position)
          m1,       // marker "from"
          m2;       // marker "to"

        // update marker
        function updateMarker(marker, isM1){
          if (isM1){
            m1 = marker;
          } else {
            m2 = marker;
          }
          updateDirections();
        }

        // add marker and manage which one it is (A, B)
        function addMarker(isM1){
          // clear previous marker if set
          var clear = {name:"marker"};
          if (isM1 && m1) {

            clear.tag = "from";
            $map.gmap3({clear:clear});
          } else if (!isM1 && m2){
            clear.tag = "to";
            $map.gmap3({clear:clear});
          }
          // add marker and store it
          $map.gmap3({
            marker:{
              latLng:current.latLng,

              options:{
                draggable:true,
                icon:new google.maps.MarkerImage("http://maps.gstatic.com/mapfiles/icon_green" + (isM1 ? "A" : "B") + ".png")
              },
              tag: (isM1 ? "from" : "to"),
              events: {
                dragend: function(marker){
                  updateMarker(marker, isM1);
                }
              },
              callback: function(marker){
                updateMarker(marker, isM1);
              }
            }
          });
        }

        // function called to update direction is m1 and m2 are set
        function updateDirections(){
          if (!(m1 && m2)){
            return;
          }
          $map.gmap3({
            getroute:{
              options:{
                origin:m1.getPosition(),
                destination:m2.getPosition(),
                travelMode: google.maps.DirectionsTravelMode.DRIVING
              },
              callback: function(results){
                if (!results) return;
                $map.gmap3({get:"directionsrenderer"}).setDirections(results);
                temp = results;
                $('.origem').attr("value",temp.request.origin.A+","+temp.request.origin.F);
                $('.destino').attr("value",temp.request.destination.A+","+temp.request.destination.F);
              }
            }
          });
        }

        // MENU : ITEM 1
        menu.add("Ponto de Destino", "itemB",
          function(){
            menu.close();
            addMarker(false);
          });

        // MENU : ITEM 2
        menu.add("Ponto de Origem", "itemA separator",
          function(){
            menu.close();
            addMarker(true);
          })

        // MENU : ITEM 3
        menu.add("Aumentar Zoom", "zoomIn",
          function(){
            var map = $map.gmap3("get");
            map.setZoom(map.getZoom() + 1);
            menu.close();
          });

        // MENU : ITEM 4
        menu.add("Diminuir Zoom", "zoomOut",
          function(){
            var map = $map.gmap3("get");
            map.setZoom(map.getZoom() - 1);
            menu.close();
          });

        // MENU : ITEM 5
        menu.add("Centralize aqui", "centerHere",
          function(){
              $map.gmap3("get").setCenter(current.latLng);
              menu.close();
          });

        // INITIALIZE GOOGLE MAP
        $map.gmap3({

             getgeoloc : {
                  callback : function(latLng) {
                    if (latLng) {
                          $(this).gmap3({
                            marker : {
                            latLng : latLng
                          },
                          map:{
                            options:{
                                center:latLng,
                                zoom: 16
                            }
                          }
                        });
                        } else {
                         // alert("nÃ£o encontrou")
                         // $('#test1-result').html('not localised !');
                        }
                }
          },

           map:{
            events:{
              rightclick:function(map, event){
                current = event;
                menu.open(current);
              },
              click: function(){
                menu.close();
              },
              dragstart: function(){
                menu.close();
              },
              zoom_changed: function(){
                menu.close();
              }
            }
          },
          // add direction renderer to configure options (else, automatically created with default options)
          directionsrenderer:{
            divId:"directions",
            options:{
              preserveViewport: true,
              markerOptions:{
                visible: false
              }
            }
          }


        });

      });

    </script>
  </head>

  <body>
    <div id="container">
    
      <div id="directions">
      	<c:if test="${!empty listaDeRotas}">
			<select>
			<option value="">Lista de Rotas Cadastradas</option>
			<c:forEach items="${listaDeRotas}" var="rota">
			  <option value="${rota.id}">${rota.nome}</option>
			</c:forEach>
			</select>
		</c:if>
      </div>
      
      <div id="googleMap"></div>
      
      <div id="form">
      <c:url var="salvarRota" value="/rota/addRota"></c:url>
      <form action="${salvarRota}" method="post">
      	<input type="text" name="nome" />
      	<input class="origem" type="hidden" name="origem" />
      	<input class="destino" type="hidden" name="destino" />
    
      	<c:if test="${!empty user_id}">
      		<input class="userID" type="hidden" name="user_Id" value="${user_id}" />
      	</c:if>
      	<c:if test="${!empty USERID}">
      		<input class="userID" type="hidden" name="user_Id" value="${USERID}" />
      	</c:if>
    
      	<input type="submit" value="Salvar rota" />
      	</form>
      </div> <!--FIM FORM -->
      
      <div id="rotas">
      	
      </div>
     
      </div><!-- FIM CONTAINER-->
  </body>
</html>