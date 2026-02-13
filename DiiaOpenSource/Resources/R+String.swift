import Foundation

enum R {
    enum Strings: String {
        // MARK: - Accessibility
        case general_accessibility_close
        case general_accessibility_back_button_label
        case main_screen_accessibility_top_qr_scanner_button
        case main_screen_accessibility_bottom_bar_cell_have_updates
        
        case documents_accessibility_change_order_label
        case documents_accessibility_change_order_hint
        case documents_accessibility_change_order_announce
        
        // MARK: - General
        case general_cancel
        case general_problem_ok
        
        // MARK: - Authorization
        case authorization_welcome
        case authorization_authorization
        case authorization_forget
        case authorization_triple_error
        case authorization_repeat
        case authorization_authorize
        case authorization_info
        case authorization_personal_data_message
        case authorization_enter_pin_title
        case authorization_dont_remember_pin
        case authorization_new_pin_details
        case authorization_repeat_pin_details
        
        // MARK: - DocumentsGeneral
        case document_reordering_title
        case document_reordering_docs_number_small
        case document_reordering_docs_number_big
        
        // MARK: - Menu
        case menu_support
        case menu_title_settings
        case menu_change_pin
        case menu_logout
        case menu_logout_title
        case menu_logout_message
        case menu_logout_cancel
        case menu_change_pin_success_emoji
        case menu_change_pin_success_title
        case menu_change_pin_success_description
        case menu_change_pin_thank
        
        // MARK: - Settings
        case settings_docs_order

        // MARK: - Main
        case main_screen_feed
        case main_screen_menu
        case main_screen_documents
        
        // MARK: - QRCodeScanner
        case photo_problem
        case photo_problem_description
        case permissions_camera_not_granted
        case permissions_camera_settings
        case permissions_settings
        case permissions_exit
        case qr_incorrect_code
        
        // MARK: - DocumentsCopyRequest
        case doc_copy_title
        
        // MARK: - User identification
        case user_identification_start_title
        case user_identification_start_details
        
        // MARK: - Errors
        case error_no_internet
        
        // MARK: - Feed
        case feed_ticker_label
        case feed_qr_title
        
        // MARK: - Service
        case services_list_title
        case public_services_search_empty
        case public_services_search_placeholder
        case public_services_search
        case services_unavailable
        
        // MARK: - Documents
        case pid_document_name
        case mdl_document_name
        case cor_document_name
        
        func localized() -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.main, comment: "")
            return localized
        }
        
        func formattedLocalized(arguments: CVarArg...) -> String {
            let localized = NSLocalizedString(rawValue, bundle: Bundle.main, comment: "")
            return String(format: localized, arguments)
        }
    }
}
