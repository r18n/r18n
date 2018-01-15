# frozen_string_literal: true

module R18n
  module Locales
    # Thai locale
    class Th < Locale
      set(
        title: 'ภาษาไทย',

        wday_names: %w[วันอาทิตย์ วันจันทร์ วันอังคาร วันพุธ วันพฤหัสบดี
                       วันศุกร์ วันเสาร์],
        wday_abbrs: %w[อาทิตย์ จันทร์ อังคาร พุธ พฤหัสบดี ศุกร์ เสาร์],

        month_names: %w[มกราคม กุมภาพันธ์ มีนาคม เมษายน พฤษภาคม มิถุนายน
                        กรกฎาคม สิงหาคม กันยายน ตุลาคม พฤศจิกายน ธันวาคม],
        month_abbrs: %w[ม.ค. ก.พ. มี.ค. เม.ย. พ.ค. มิ.ย. ก.ค. ส.ค. ก.ย. ต.ค.
                        พ.ย. ธ.ค.],

        date_format: '%d/%m/%Y',
        full_format: '%e %B',
        year_format: '_, %Y',

        number_decimal: '.',
        number_group:   ','
      )

      def pluralize(_n)
        'n'
      end

      def strftime(time, format)
        year = (time.year + 543).to_s
        super(time, format.gsub('%Y', year).gsub('%y', year[-2..-1]))
      end
    end
  end
end
