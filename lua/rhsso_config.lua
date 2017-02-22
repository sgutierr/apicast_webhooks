
-- Set your RH SSO configuration below: 
local server = "http://ec2-54-200-194-114.us-west-2.compute.amazonaws.com"
local realm = "3scale"
local initial_access_token = "eyJhbGciOiJSUzI1NiIsImtpZCIgOiAiZEtzRWFKSmZqMlFVN0xpQkxReGcwQWc2NWYwREEyYnR3VFpHUlFlXzBPUSJ9.eyJqdGkiOiJmMTZmMmZkYi04MGViLTQ4Y2QtYjFkZi03MjEwNjYwODJiYjUiLCJleHAiOjE0OTkwNzY3NTksIm5iZiI6MCwiaWF0IjoxNDg1MjUyNzU5LCJpc3MiOiJodHRwOi8vZWMyLTU0LTIwMC0xOTQtMTE0LnVzLXdlc3QtMi5jb21wdXRlLmFtYXpvbmF3cy5jb20vYXV0aC9yZWFsbXMvM3NjYWxlIiwiYXVkIjoiaHR0cDovL2VjMi01NC0yMDAtMTk0LTExNC51cy13ZXN0LTIuY29tcHV0ZS5hbWF6b25hd3MuY29tL2F1dGgvcmVhbG1zLzNzY2FsZSIsInR5cCI6IkluaXRpYWxBY2Nlc3NUb2tlbiJ9.Q16J1v6KN613PC15jW6pVQVOU9MaFRJE-_ZBL2MAw6owEbaFOfxMj4uR1DXauH4xmLII6gUAAzvYQT3RMIbu_Pt3x6PzwXf1IwE950GllKXrhixUWOd2CfdrAbAtkZe_girJmuHazFzd4sQ54TSQBgcOzoGNwk73_ukrqFMzIQaRNptzoq64V4roTxwKlX5ZIaCTyAH0GW9MaxA6qCT80HZYaLd29OvrPEYDkoxipW7gDDKhTvUlv14kSsvr3f1CxnRP0I1N1jHr95kdAdEYZfF-Ht0Ud9VdnxI7jjzzdxdkTCdlJfRiNK03S6VMuFyhf2sQeuLaY1x1XBCHB1cfkw"

local public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuN7j2OdS+xgG54hzb8ILTkHHzDIsHep3BFeYyKD2wjWFXEgjmnYUIxP9e1L89vjk5puYlIKzB+j5YQa4Hb7NfOUaxBGyb6Rk1Yk0+o8uTeh8SlA4aJ0q4CiUnHRyxkbAwsXY1JdlYiRpWrsTzGHpUMxfYIJy6IYpa9MIxdMiVkQG4IKd3rPlzoP5XYUauFNCexXOtJHM6YX8aFfTLa4iG+HaJajLilObzPTEZi3STX8RyeK/UUuhBCk7SSGI6l7/JKTXvS+TEwUcGL+QM4NIsuwabFKAAhAF52OGBoHSOkFcsJRDC+daEpgudtqR+mxwKPqfmdk+7bvjn653p2Jj4wIDAQAB"


local function format_public_key(key)
  local formatted_key = "-----BEGIN PUBLIC KEY-----\n"
  local len = string.len(key)
  for i=1,len,64 do
    formatted_key = formatted_key..string.sub(key, i, i+63).."\n"
  end
  formatted_key = formatted_key.."-----END PUBLIC KEY-----"
  return formatted_key
end

return {
  server = server,
  authorize_url = server..'/auth/realms/'..realm..'/protocol/openid-connect/auth',
  token_url = server..'/auth/realms/'..realm..'/protocol/openid-connect/token',
  client_registrations_url = server..'/auth/realms/'..realm..'/clients-registrations/default',
  initial_access_token = initial_access_token,
  public_key = format_public_key(public_key)
}
