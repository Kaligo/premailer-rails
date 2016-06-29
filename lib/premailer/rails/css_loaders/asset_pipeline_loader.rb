class Premailer
  module Rails
    module CSSLoaders
      module AssetPipelineLoader
        extend self

        def load(url)
          if asset_pipeline_present?
            asset = find_asset(url)
            asset.to_s if asset
          end
        end

        def asset_pipeline_present?
          defined?(::Rails) &&
            ::Rails.respond_to?(:application) &&
            ::Rails.application.respond_to?(:assets) &&
            ::Rails.application.assets
        end

        def find_asset(url)
          if ::Rails.configuration.assets.compile
            url
          else
            ::Rails.application.assets_manifest.assets[file_name(url)]
          end
        end

        def file_name(url)
          prefix = [
            ::Rails.configuration.relative_url_root,
            ::Rails.configuration.assets.prefix,
            '/'
          ].join
          URI(url).path
            .sub(/\A#{prefix}/, '')
            .sub(/-(\h{32}|\h{64})\.css\z/, '.css')
        end
      end
    end
  end
end
