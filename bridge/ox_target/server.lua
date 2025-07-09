lib.callback.register("mri_Qinteract:Server:StopTarget", function(source)
    StopResource('ox_target')
    return true
end)