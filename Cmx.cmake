if (NOT CMX_INCLUDED)
	include(FetchContent)

	include(CmxInferVersion)
	include(CmxPlatform)
	include(CmxScripts)

	include(CmxSdl2)
	include(CmxSdl2Image)
	include(CmxSdl2Mixer)
	include(CmxSdl2Net)
	include(CmxSdl2Rtf)
	include(CmxSdl2Ttf)

	include(CmxKstdCore)
	include(CmxKstdReflect)
	include(CmxKstdPlatform)
	include(CmxKstdStreams)
	include(CmxKstdIo)
	include(CmxKstdResource)

	include(CmxGoogleTest)
	include(CmxFmt)
	include(CmxAtomicQueue)
	include(CmxParallelHashmap)
	include(CmxZlib)

	include(CmxApplication)
	include(CmxLibrary)

	set(CMX_INCLUDED ON)
endif()
