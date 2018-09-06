Pod::Spec.new do |s|
    s.name = 'DJIWidget'
    s.version = '1.0'
    s.author = { 'Lacklock' => 'lacklock@gmail.com',
                 'Owen'     => 'wen.pandara@gmail.com' }
    s.license = { :type => 'CUSTOM', :text => <<-LICENSE
****************************************************************************************************************************

DJI Mobile SDK for iOS is offered under DJI's END USER LICENSE AGREEMENT. You can obtain the license from the below link:
http://developer.dji.com/policies/eula/

****************************************************************************************************************************
    LICENSE
    }

    s.homepage = 'https://github.com/gzkiwiinc/Mobile-SDK-iOS'
    s.source = { :git => 'git@github.com:gzkiwiinc/Mobile-SDK-iOS.git', :tag => "w#{s.version}"}
    s.summary = 'DJIWidget'
    s.platform = :ios, '10.0'

    s.vendored_frameworks = 'Sample code/DJIWidget/FFmpeg/FFmpeg.framework'
    s.frameworks = 'Foundation', 'CoreGraphics', 'CoreMedia', 'FFmpeg'

    s.module_name = 'DJIWidget'

    s.source_files = 'Sample code/DJIWidget/DJIWidget/*.{h,m,c}', 'Sample code/DJIWidget/DJIWidget/**/*.{h,m,c}', 'Sample code/DJIWidget/FFmpeg/FFmpeg.framework/Headers/*.h'

    s.pod_target_xcconfig = {
        'ENABLE_BITCODE' => 'NO',
        'HEADER_SEARCH_PATHS' => '$(inherited) "$(PROJECT_DIR)/DJIWidget/Sample Code/DJIWidget/FFmpeg/FFmpeg.framework/Headers"',
    }
    
    s.dependency 'DJI-SDK-iOS', '~> 4.7.1'

    s.subspec 'DJIVideoPreviewerExtension' do |ss|
        ss.source_files = 'DJIVideoPreviewerExtension/*.{h,m}'
        ss.public_header_files = 'DJIVideoPreviewerExtension/*.h'
    end

end
