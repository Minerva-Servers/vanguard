local Color = Color
local FrameTime = FrameTime
local CurTime = CurTime
local Lerp = Lerp
local draw = draw
local surface = surface
local vgui = vgui

local PANEL = {}

function PANEL:Init()
    self:SetFont("Vanguard.Button")
    self:SetTextColor(color_white)
    self:SetExpensiveShadow(1, Color(0, 0, 0, 255))
    self:SetContentAlignment(5)
    self:SetCursor("hand")
    self:SetTextInset(8, 0)

    self.colorLerp = Color(40, 40, 40, 255)
    self.colorTarget = Color(40, 40, 40, 255)
    self.colorFlash = Color(0, 0, 0, 255)
    self.colorFlashTime = 0
end

function PANEL:Paint(width, height)
    local ft = FrameTime()
    local time = ft * 10

    if ( self.colorFlashTime > CurTime() ) then
        self.colorLerp.r = Lerp(time, self.colorLerp.r, self.colorFlash.r)
        self.colorLerp.g = Lerp(time, self.colorLerp.g, self.colorFlash.g)
        self.colorLerp.b = Lerp(time, self.colorLerp.b, self.colorFlash.b)
    else
        self.colorLerp.r = Lerp(time, self.colorLerp.r, self.colorTarget.r)
        self.colorLerp.g = Lerp(time, self.colorLerp.g, self.colorTarget.g)
        self.colorLerp.b = Lerp(time, self.colorLerp.b, self.colorTarget.b)
    end

    draw.RoundedBox(8, 0, 0, width, height, self.colorLerp)
end

function PANEL:OnCursorEntered()
    self.colorTarget = vanguard.info.color
end

function PANEL:OnCursorExited()
    self.colorTarget = Color(40, 40, 40, 255)
end

function PANEL:OnMousePressed(keyCode)
    self.colorFlash = Color(0, 0, 0, 255)
    self.colorFlashTime = CurTime() + 0.1

    surface.PlaySound("buttons/lightswitch2.wav")

    if ( keyCode == MOUSE_LEFT ) then
        if ( self.DoClick ) then
            self:DoClick()
        end
    elseif ( keyCode == MOUSE_RIGHT ) then
        if ( self.DoRightClick ) then
            self:DoRightClick()
        end
    end
end

vgui.Register("Vanguard.Button", PANEL, "DButton")