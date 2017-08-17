width = window.innerWidth
height = window.innerHeight - 120

activeDate = new Date()
formatDate = (d) -> "#{d.getFullYear()}_#{('0'+(d.getMonth()+1)).slice(-2)}_#{('0'+d.getDate()).slice(-2)}"

svg = d3.select("svg")
svg.attr("width", width)
svg.attr("height", height)

links = undefined
nodes = undefined
d3link = undefined
d3node = undefined
nodeMax = undefined
linkMax = undefined

calcNodeSize = (d) -> 5+35*(d.volume/nodeMax)
calcLinkWidth = (d) -> 0.1 + (d.volume/linkMax)
calcLinkStroke = (d) ->
  col = "#FFF"
  if d.source.etype=="start" or d.target.etype=="start"
    col = "#0F0"
  if d.target.etype=="end" or d.source.etype=="end"
    col = "#F00"
  col
getMax = (items)->
  max = 0
  items.forEach (i)-> max = vol if (vol = parseInt(i.volume)) > max
  max

considerFixedPosition = (d)->
  if d.etype == "start"
    d.x = 20
    d.y = 20
  else if d.etype == "end"
    d.x = width - 20
    d.y = height - 20

d3.csv "csv/GenerateLinksForSiteVisualization_#{formatDate activeDate}.csv", (link_error, _links) ->
  throw link_error if link_error
  links = _links
  self_directed_links = links.filter (e,i,a)->e.source==e.target
  links = links.filter (e,i,a)->e.source!=e.target
  linkMax = getMax links

  d3.csv "csv/GenerateNodesForSiteVisualization_#{formatDate activeDate}.csv", (node_error, _nodes) ->
    throw node_error if node_error
    nodes = _nodes
    nodeMax = getMax nodes

    simulation = d3.forceSimulation()
      .force('link', d3.forceLink().id((d) -> d.id))
      .force('charge', d3.forceManyBody())
      .force('center', d3.forceCenter(width / 2, height / 2))
      .force('collide', d3.forceCollide().radius(calcNodeSize).iterations(2))

    simulation.velocityDecay(0.8)
    simulation.alphaDecay(0.001)

    dragstarted = (d) ->
      if !d3.event.active
        simulation.alphaTarget(0.3).restart()
      d.fx = d.x
      d.fy = d.y
      return

    dragged = (d) ->
      d.fx = d3.event.x
      d.fy = d3.event.y
      return

    dragended = (d) ->
      if !d3.event.active
        simulation.alphaTarget 0
      d.fx = null
      d.fy = null
      return

    d3links = svg.append("g")
        .attr("class", "links")
        .selectAll("line")
        .data(links)
        .enter()
        .append("line")
        .attr("stroke-width", 3)
        .attr("opacity", calcLinkWidth)

    d3nodes = svg.append("g")
        .attr("class", "nodes")
        .selectAll("circle")
        .data(nodes)
        .enter().append("circle")
        .attr("r", calcNodeSize)
        .attr("fill", (d)-> if d.cv_count > 0 then "#FF0" else "#FFF")
        .on("mouseover", (d) -> displayDetail(d.path, d.title, d.volume, d.id))
        .call(d3.drag()
            .on("start", dragstarted)
            .on("drag", dragged)
            .on("end", dragended))

    ticked = ->
      nodes.forEach considerFixedPosition
      d3links
        .attr("x1", (d) -> d.source.x )
        .attr("y1", (d) -> d.source.y )
        .attr("x2", (d) -> d.target.x )
        .attr("y2", (d) -> d.target.y )
      d3nodes
        .attr("cx", (d) -> d.x)
        .attr("cy", (d) -> d.y)

    simulation.nodes(nodes).on 'tick', ticked
    simulation.force('link').links(links).distance((d)-> ((linkMax - d.volume)/linkMax)*300 + 10).strength(0.3)
    d3links.attr("stroke", calcLinkStroke)

isAllowedOpenDetail = false

resetActiveNode = ()->
  activeNode = null

c = (t)-> console.log t

openDetail = (path) ->
  c "openDetail"
  if isAllowedOpenDetail
    window.open().location.href = "http://" + path

prepareOpenDetail = ()->
  c "prepareOpenDetail"
  isAllowedOpenDetail = true

preventOpenDetail = ()->
  c "preventOpenDetail"
  isAllowedOpenDetail = false

displayDetail = (path, title, volume, id)->
  c "displayDetail"
  activeNode = id
  detail_panel = document.querySelector("#detail_panel")
  title_elm = detail_panel.querySelector(".title")
  title_elm.textContent = title
  path_elm = detail_panel.querySelector(".path")
  path_elm.setAttribute('href', "http://" + path)
  path_elm.textContent = path
  vol_elm = detail_panel.querySelector(".volume")
  vol_elm.textContent = volume
