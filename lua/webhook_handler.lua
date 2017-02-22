local redis_pool = require 'redis_pool'
local lom = require 'lxp.lom'
local xpath = require 'luaxpath'
local inspect = require 'inspect'

local _M = {}

local function client_registration_request(method, client_details)
  local body = { 
    clientId = client_details.client_id, 
    secret = client_details.client_secret,
    name = client_details.name,
    description = client_details.description,
    consentRequired = true -- we want the user to give consent
  }
  if client_details.redirect_url then 
    body.redirectUris = { client_details.redirect_url }
  end

  local res = ngx.location.capture("/register_client", { 
      method = method,
      body = cjson.encode(body),
      copy_all_vars = true })
      ngx.log(0,"SERGIO ESTADO despues de registrar cliente:"..inspect(res))
  return res
end

local function register_client(client_details)
  ngx.var.access_token = rhsso.initial_access_token
  ngx.var.registration_url = rhsso.client_registrations_url
  local method = ngx.HTTP_POST
  ngx.log(0,'IR A REGISTRATION REQUEST')
  client_registration_request(method, client_details)
end

local function update_client(client_details)
  local client_id = client_details.client_id
  ngx.var.registration_url = rhsso.client_registrations_url..'/'..client_id
  local method = ngx.HTTP_PUT
  client_registration_request(method, client_details)
end

function _M.handle()
  ngx.req.read_body()
  local body = ngx.req.get_body_data()

  if body then
    local root = lom.parse(body)
    local action = xpath.selectNodes(root, '/event/action/text()')[1]
    local t = xpath.selectNodes(root, '/event/type/text()')[1]
    if (t == 'application' and (action == 'updated' or action == 'created')) then

      local client_details = { 
        client_id = xpath.selectNodes(root, '/event/object/application/application_id/text()')[1],
        client_secret = xpath.selectNodes(root, '/event/object/application/keys/key/text()')[1],
        redirect_url = xpath.selectNodes(root, '/event/object/application/redirect_url/text()')[1],
        name = xpath.selectNodes(root, '/event/object/application/name/text()')[1],
        description = xpath.selectNodes(root, '/event/object/application/description/text()')[1]
      }
        ngx.log(ngx.ERR, '****SERGIO**'..client_details.client_id)
      if action == 'created' then
        ngx.log(0,'VOY A registrar')
        register_client(client_details)
      elseif action == 'updated' then
             ngx.log(ngx.ERR, '****SERGIO2**'..client_details.client_id) 
        update_client(client_details)
      end      
    end
  end
end

return _M
