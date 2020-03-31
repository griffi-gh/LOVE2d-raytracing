return {
  spawn=function(x,y,d,ma,ca)
    d=d or 360
    ma=ma or 360
    ca=ca or 0
    local rays={}
    for i=1,d do
      local p=#rays+1
      local ca=i/d*ma+ca
      rays[p]={
        x=x,y=y,
        dx=x,dy=y,
        ca=ca,
        v={x=math.cos(math.rad(ca)),y=math.sin(math.rad(ca))},
        blocked=false,
      }
    end
    return rays
  end,
  
  trace=function(r,o,ts,rs)
    rs=rs or 1
    ts=ts or 250
    for i=0,ts do
      for i,v in ipairs(r) do
        if not v.blocked then
          v.x=v.x+v.v.x*rs
          v.y=v.y+v.v.y*rs
          for i2,o2 in ipairs(o) do
            if(v.x>o2.x and v.y>o2.y and v.x<o2.x+o2.w and v.y<o2.y+o2.h)then
              if(o2.type=='wall')then
                v.blocked=true
                v.hit=i2
              end
            end
          end
        end
      end
    end
  end,
  
  draw=function(r,o)
    for i,v in ipairs(r) do
      lg.setColor(0.7,0.7,0.7)
      lg.line(v.dx,v.dy,v.x,v.y)
    end
    lg.setColor(1,0.3,0.3)
    for i,v in ipairs(o) do
      lg.rectangle('fill',v.x,v.y,v.w,v.h)
    end
    
    local xi=0
    local lastScale=1
    for i,v in ipairs(r) do
      if v.blocked then
        local LEN2=LEN*RAYSP
        local dist=distanceFrom(v.dx,v.dy,v.x,v.y)
        local distC=dist*math.cos(math.rad(v.ca - player.ang - player.fov/2) * 1.09 )
        local dist2=math.max(LEN2-distC,0)
        local c=dist2/LEN2
        local hitObj=o[v.hit] --hitObj.texture !
        
        love.graphics.setColor(c,c,c)
        
        local off=dist2/LEN2*WALLH/2
        
        if(hitObj.texture)then
          xi=xi+1
          
          local function getVscale(t)
            if(t)then
              return 1/t:getHeight()*(off*2) 
            end
          end
          
          local function drawIt(t) 
            if(t)then 
              lg.draw(t,i,h/2-off,0,1,getVscale(t))
              return getVscale(t)
            end 
          end
          
          if(type(hitObj.texture)=='table')then
            local TEX=hitObj.texture
            if not(hitObj.offs) or (hitObj.offs or 0)>#TEX-2 or xi==1 then
              hitObj.offs=1
            else
              hitObj.offs=hitObj.offs+1/(lastScale or 1)
            end
            lastScale=drawIt(TEX[math.floor(hitObj.offs)])
          else
            drawIt(hitObj.texture)
          end
          
        else
          lg.line(i,h/2-off,i,h/2+off)
        end
      end
    end
  end,
}