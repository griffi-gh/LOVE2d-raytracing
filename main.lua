l  = love
lf = l.filesystem
ls = l.sound
la = l.audio
lp = l.physics
lt = l.timer
li = l.image
lg = l.graphics
lw = love.window
lm = l.mouse
lk = l.keyboard
s=','

ton=function(b) local n=0 if(b)then n=1 end return n end
function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

ray=require'ray'

function cutImg(i)
  local img={}
  local iw,ih=i:getWidth(),i:getHeight()
  local function crop(im,crx,cry,crw,crh)
    local cr=li.newImageData(crw,crh)
    cr:paste(im,0,0,crx,cry,cw,ch)
    return lg.newImage(cr)
  end
  for j=1,iw do
    img[#img+1]=crop(i,j,1,1,ih)
  end
  return img
end

player={
  x=100,
  y=100,
  fov=60,
  ang=0,
  sp=2,
}
Stex={lg.newImage('tex1.png')}
Atex={li.newImageData('tex2.png')}
obj={{x=200,y=100,w=10,h=300,texture=cutImg(Atex[1]),type='wall'},{x=200,y=100,w=300,h=10,texture=nil,type='wall'}}

function love.load()
  LEN=200
  RAYSP=2
  WALLH=300
end

function love.update(dt)
  w,h=lg.getWidth(),lg.getHeight()
  local pcx,pcy=ton(lk.isDown('right'))-ton(lk.isDown('left')),ton(lk.isDown('down'))-ton(lk.isDown('up'))
  player.ang=player.ang+pcx*2
  local xAr,yAr=math.cos(math.rad(player.ang+player.fov/2)),math.sin(math.rad(player.ang+player.fov/2))
  player.x,player.y=player.x+xAr*pcy*-player.sp,player.y+yAr*pcy*-player.sp
  
  rays=ray.spawn(player.x,player.y,180,player.fov,player.ang)--x,y,c,fov,ang
  ray.trace(rays,obj,LEN,RAYSP)--r,o,timestep,sp
end

function love.draw()
  ray.draw(rays,obj)
  lg.setColor(1,1,1)
  lg.print(lt.getFPS()..s..player.ang..s..player.ang+player.fov..s..(debug3 or ''),0,0)
end


--test
--local y1=(h/2)*(1-(1/dist2)) local y2=(h/2)*(1+(1/dist2)) lg.line(i,y1,i,y2) //// *math.cos(math.rad(v.ca))