rays={}
rayStart={x=399,y=299}
boxes={{x=100,y=100,w=30,h=30},{x=700,y=300,w=50,h=80},{x=600,y=80,w=100,h=40}}

raySpeed=3 --bigger value=better fps and speed, worse accuracy
timesteps=250 --bigger value=worse fps, better speed
raysCount=360*4 --bigger value=worse fps,more rays/accuracy

function bts(b,st,sf) st=st or 'true' sf=sf or 'false' if(b)then return st else return sf end end 

function spawn(filter)
  local filter=filter or function(a,i,px,py) return true end
  rays={}
  local imax=raysCount
  for i=1,imax do
    local i2=i/(imax-0)
    if(i>=0 and i<90/360*imax)then
      px,py=i2,-i2
    elseif(i>=90/360*imax and i<180/360*imax)then
      px,py=i2,i2
    elseif(i>=180/360*imax and i<270/360*imax)then
      px,py=-i2,i2
    else
      px,py=-i2,-i2
    end
    
    if filter(i/imax*360,i,px,py) then
      rays[#rays+1]={x=rayStart.x,y=rayStart.y,a={x=math.cos(math.rad(px*360)),y=math.sin(math.rad(py*360))}}
    end
  end
end

function love.load()
  love.keypressed('v')
  raysCount=raysCount+1
  spawn()
  love.mousemoved(0,0) 
end

function love.update(dt)
  
end

function love.mousemoved(x,y,dx,dy)
  mx,my=x,y
end

function love.keypressed(key)
  if key=='v' then
    if not(vsyncOff) then
      vsyncOff=true
      love.window.setVSync(0)
    else
      vsyncOff=false
      love.window.setVSync(1)
    end
  end
end

function love.draw()
  m1=love.mouse.isDown(1)
  w,h=love.graphics.getWidth(),love.graphics.getHeight()
  
  moving=false
  if(m1)then
    if not(rayStart.x==mx and rayStart.y==my) then
      rayStart={x=mx,y=my}
      spawn()
      moving=true
    end
  end
  
  local ct=timesteps
  if finished and not(moving) then
    ct=1
  end
  for it=1,ct do
    love.graphics.setColor(0.5,0.5,0.5)
    traced=0
    for i,v in ipairs(rays) do
      local blocked=false
      for i2,v2 in ipairs(boxes) do
        if (v.x>v2.x and v.x<v2.x+v2.w and v.y>v2.y and v.y<v2.y+v2.h)or(v.x<0 or v.x>=w or v.y<0 or v.y>=h) then
          if not(blocked)then
            traced=traced+1
            blocked=true
          end
        end
      end
      if not(blocked) then
        v.x=v.x+v.a.x*raySpeed
        v.y=v.y+v.a.y*raySpeed
      end
      if(it==ct)then
        love.graphics.line(rayStart.x,rayStart.y,v.x,v.y)
      end
    end
  end
  finished=(#rays==traced)
  
  love.graphics.setColor(0.75,0,0)
  for i,v in ipairs(boxes) do
    love.graphics.rectangle('fill',v.x,v.y,v.w,v.h)
  end
  
  love.graphics.setColor(0.75,1,0.5)
  love.graphics.circle('fill',rayStart.x,rayStart.y,5)
  
  love.graphics.setColor(1,1,1)
  
  love.graphics.print(
    love.timer.getFPS()..' FPS\tvsync'..
    bts(vsyncOff,' off',' on')..' (V)\ttraced:'..traced..
    '/'..#rays..'/'..raysCount..'\t'..bts(finished,'OK!','BUSY')..
    '\nraySpeed:'..raySpeed..'\ttimestep:'..ct
    ,0,0
  )
end