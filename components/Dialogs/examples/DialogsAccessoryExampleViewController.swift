// Copyright 2019-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import MaterialComponents.MaterialCollections
import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialDialogs_Theming 
import MaterialComponents.MaterialTextControls_FilledTextFields 
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming 
import MaterialComponents.MaterialContainerScheme
import MaterialComponents.MaterialTypographyScheme

class DialogsAccessoryExampleViewController: MDCCollectionViewController {

  @objc var containerScheme: MDCContainerScheming = MDCContainerScheme()

  let attributedText: NSAttributedString = {
    typealias AttrDict = [NSAttributedString.Key: Any]
    let bgAttr: AttrDict = [.backgroundColor: UIColor.blue.withAlphaComponent(0.2)]
    let orangeAttr: AttrDict = [.foregroundColor: UIColor.orange]
    let linkAttr: AttrDict = [.link: URL(string: "https://www.google.com/search?q=lorem+ipsum")!]

    let attributedText = NSMutableAttributedString()
    attributedText.append(NSAttributedString(string: "Lorem ipsum", attributes: linkAttr))
    attributedText.append(NSAttributedString(string: " dolor sit amet, ", attributes: nil))
    attributedText.append(
      NSAttributedString(
        string: "consectetur adipiscing elit, sed do ",
        attributes: nil))
    attributedText.append(NSAttributedString(string: " eiusmod ", attributes: bgAttr))
    attributedText.append(NSAttributedString(string: " tempor incididunt ut ", attributes: nil))
    attributedText.append(NSAttributedString(string: "labore magna ", attributes: orangeAttr))
    attributedText.append(NSAttributedString(string: "aliqua.", attributes: nil))
    return attributedText
  }()

  let kReusableIdentifierItem = "customCell"

  var menu: [String] = []

  var handler: MDCActionHandler = { action in
    print(action.title ?? "Some Action")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = containerScheme.colorScheme.backgroundColor

    loadCollectionView(menu: [
      "Text View",
      "Title + Message + UI Text Field",
      "Material Filled Text Field",
      "Custom Label and Button (autolayout)",
      "Default Attributed Label and Button",
    ])
  }

  func loadCollectionView(menu: [String]) {
    self.collectionView?.register(
      MDCCollectionViewTextCell.self, forCellWithReuseIdentifier: kReusableIdentifierItem)
    self.menu = menu
  }

  override func collectionView(
    _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
  ) {
    guard let alert = performActionFor(row: indexPath.row) else { return }
    self.present(alert, animated: true, completion: nil)
  }

  private func performActionFor(row: Int) -> MDCAlertController? {
    switch row {
    case 0:
      return performTextView()
    case 1:
      return performTextField()
    case 2:
      return performMDCTextField()
    case 3:
      return performCustomLabelWithButton()
    case 4:
      return performDefaultLabelWithButton()
    default:
      print("No row is selected")
      return nil
    }
  }

  func performTextView() -> MDCAlertController {
    let alert = MDCAlertController()
    let textView = UITextView()
    textView.attributedText = attributedText
    textView.font = MDCTypographyScheme().body1
    textView.isEditable = false
    textView.isScrollEnabled = false
    alert.accessoryView = textView
    alert.addAction(MDCAlertAction(title: "Dismiss", emphasis: .medium, handler: handler))
    alert.applyTheme(withScheme: self.containerScheme)
    return alert
  }

  func performTextField() -> MDCAlertController {
    let alert = MDCAlertController(title: "This is a title", message: "This is a message")
    let textField = UITextField()
    textField.placeholder = "This is a text field"
    alert.accessoryView = textField
    alert.addAction(MDCAlertAction(title: "Dismiss", emphasis: .medium, handler: handler))
    alert.applyTheme(withScheme: self.containerScheme)
    return alert
  }

  func performMDCTextField() -> MDCAlertController {
    let alert = MDCAlertController(title: "Rename File", message: nil)
    alert.addAction(MDCAlertAction(title: "Rename", emphasis: .medium, handler: handler))
    alert.addAction(MDCAlertAction(title: "Cancel", emphasis: .low, handler: handler))

    if let alertView = alert.view as? MDCAlertControllerView {
      alertView.contentInsets.bottom = 16.0
    }
    let view = UIView(frame: CGRect.zero)
    let label = newLabel(text: "OLD_FILE.PNG will be renamed:")

    let namefield = MDCFilledTextField()
    namefield.label.text = "New File Name"
    namefield.placeholder = "Enter a new file name"
    namefield.labelBehavior = MDCTextControlLabelBehavior.floats
    namefield.clearButtonMode = UITextField.ViewMode.whileEditing
    namefield.leadingAssistiveLabel.text = "An optional assistive message"
    namefield.applyTheme(withScheme: containerScheme)

    label.translatesAutoresizingMaskIntoConstraints = false
    namefield.translatesAutoresizingMaskIntoConstraints = false
    view.translatesAutoresizingMaskIntoConstraints = true

    view.addSubview(label)
    view.addSubview(namefield)

    label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: namefield.topAnchor, constant: -10).isActive = true

    namefield.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    namefield.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    namefield.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    alert.accessoryView = view
    alert.applyTheme(withScheme: self.containerScheme)
    return alert
  }

  // Demonstrating a custom accessory view with auto layout, presenting a label and a button.
  func performCustomLabelWithButton() -> MDCAlertController {
    let alert = MDCAlertController(title: "Title", message: nil)
    alert.addAction(MDCAlertAction(title: "Dismiss", emphasis: .medium, handler: handler))

    let view = UIView(frame: CGRect.zero)
    let label = newLabel(text: "Your storage is full. Your storage is full.")
    let button = MDCButton()
    button.setTitle("Learn More", for: UIControl.State.normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8)
    button.applyTextTheme(withScheme: containerScheme)

    label.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false
    view.translatesAutoresizingMaskIntoConstraints = true

    view.addSubview(label)
    view.addSubview(button)

    label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: button.topAnchor).isActive = true

    button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    button.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor).isActive = true
    button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    alert.accessoryView = view
    alert.applyTheme(withScheme: self.containerScheme)
    return alert
  }

  // Demonstrating a custom accessory view with manual layout, presenting a button, while using the
  // alert's default label.
  func performDefaultLabelWithButton() -> MDCAlertController {
    let alert = MDCAlertController(title: "Title", attributedMessage: attributedText)
    alert.addAction(MDCAlertAction(title: "Dismiss", emphasis: .medium, handler: handler))

    let button = MDCButton()
    button.setTitle("Learn More", for: UIControl.State.normal)
    button.contentEdgeInsets = .zero
    button.applyTextTheme(withScheme: containerScheme)
    button.sizeToFit()

    let size = button.bounds.size
    let view = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    view.addSubview(button)

    alert.accessoryView = view
    if let alertView = alert.view as? MDCAlertControllerView {
      alertView.accessoryViewVerticalInset = 0
      alertView.contentInsets = UIEdgeInsets(top: 24, left: 24, bottom: 10, right: 24)
    }

    alert.applyTheme(withScheme: self.containerScheme)
    return alert
  }

  func newLabel(text: String) -> UILabel {
    let label = UILabel()
    label.textColor = containerScheme.colorScheme.onSurfaceColor
    label.font = containerScheme.typographyScheme.subtitle2
    label.text = text
    label.numberOfLines = 0
    return label
  }

}

// MDCCollectionViewController Data Source
extension DialogsAccessoryExampleViewController {

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(
    _ collectionView: UICollectionView, numberOfItemsInSection section: Int
  ) -> Int {
    return menu.count
  }

  override func collectionView(
    _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: kReusableIdentifierItem,
      for: indexPath)
    guard let customCell = cell as? MDCCollectionViewTextCell else { return cell }

    customCell.isAccessibilityElement = true
    customCell.accessibilityTraits = .button

    let cellTitle = menu[indexPath.row]
    customCell.accessibilityLabel = cellTitle
    customCell.textLabel?.text = cellTitle

    return customCell
  }
}

// MARK: Catalog by convention
extension DialogsAccessoryExampleViewController {

  @objc class func catalogMetadata() -> [String: Any] {
    return [
      "breadcrumbs": ["Dialogs", "Dialog With Accessory View"],
      "primaryDemo": false,
      "presentable": true,
    ]
  }
}
