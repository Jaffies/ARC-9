function SWEP:DrawWorldModel()
    if !self.MirrorVMWM then
        self:DrawModel()
        return
    end

    self:DrawCustomModel(true)

    if IsValid(self:GetOwner()) and self:GetOwner():GetActiveWeapon() == self then -- gravgun moment
        self:DoBodygroups(true)
        self:DrawLasers(true)
        self:DoTPIK()
    end
end
