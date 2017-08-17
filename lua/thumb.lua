
-- config
log_level         = ngx.NOTICE

img_thumb_bin         = '/usr/local/bin/convert'
img_thumb_bg_color    = 'white'
img_thumb_bg_mark     = '/opt/html/thumb/logo.png'

img_thumb_root        = '/opt/html/thumb/'
img_orgin_root        = '/opt/html/upload/'
img_current_path_pre  = "/thumb/"

img_uri               = ngx.var.uri
img_match_pre         = '/upload/'

--img_thumb_match_reg  = '_[0-9]+x[0-9]+'
arg_w                 = ngx.var.arg_w or 0
arg_h                 = ngx.var.arg_h or 0 
img_thumb_width       = tonumber(arg_w)
img_thumb_height      = tonumber(arg_h)

img_thumb_default_img = img_current_path_pre..'notfound.jpg'

-- function
function thumb_log(msg,level)
    level = level or log_level
    ngx.log(level,msg)
end 

function parser_orgin_dir(img_path)
  index = string.find(img_path, "/[^/]*$")
  index = index or 0
  
  dir = string.sub(img_path,0,index)
  if index >0 then       
	  file = string.sub(img_path,index+1,string.len(img_path))
  else      
	  file = string.sub(img_path,index,string.len(img_path))
  end
    
  dict = {}
  dict['dir'] = dir
  dict['file'] = file
  
  return dict;
end

function img_exists(img_path)
    if img_path == nil then
        return false
    end
    local f = io.open(img_path, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end

end

function generate_cover_command(img_orgin_path,img_thumb_path,img_thumb_width,img_thumb_height)
	local cmd = img_thumb_bin..' '..img_orgin_path	
	cmd = cmd..' -compose over '..img_thumb_bg_mark..' -composite '
	cmd = cmd..' -resize '..img_thumb_width..'x'..img_thumb_height..' -background '..img_thumb_bg_color
	cmd = cmd .. ' ' .. img_thumb_path
	return cmd
end

-- init

local _img_path = string.gsub(img_uri,img_match_pre,'')
local _img_dict = parser_orgin_dir(_img_path)
local _img_dir  = _img_dict['dir']
local _img_file = _img_dict['file']
local _img_file_path   = _img_dir..img_thumb_width..'x'..img_thumb_height..'_'.._img_file


local img_orgin_path   = img_orgin_root.._img_dir.._img_file
local img_thumb_path   = img_thumb_root.._img_file_path

local img_current_dir  = img_thumb_root.._img_dir
local img_current_path = img_current_path_pre.._img_file_path

thumb_log('img_orgin_path= '..img_orgin_path)
thumb_log('img_thumb_path= '..img_thumb_path)

thumb_log('img_current_dir= '..img_current_dir)
thumb_log('img_current_path= '..img_current_path)

-- process
if img_exists(img_thumb_path) then
	img_thumb_default_img = img_current_path
else
	if img_exists(img_orgin_path) then	
		if (0 >= img_thumb_width or 0>= img_thumb_height or 2000 <= img_thumb_width or 2000 <= img_thumb_height) then
			thumb_log('img_thumb_width= '..img_thumb_width..','..img_thumb_height)
		else
			local cmd = generate_cover_command(img_orgin_path,img_thumb_path,img_thumb_width,img_thumb_height)
			thumb_log('cmd= '..cmd)
			os.execute('mkdir -p '..img_current_dir)
			os.execute(cmd)
			img_thumb_default_img = img_current_path
		end		
	end
end

-- render
thumb_log('img_thumb_default_img= '..img_thumb_default_img)
ngx.req.set_uri_args("")
ngx.req.set_uri(img_thumb_default_img, false)








