//
//  ViewController.swift
//  ARKitNavigator
//
//  Created by Giordano Scalzo on 24/04/2019.
//  Copyright © 2019 Giordano Scalzo. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!

    @IBOutlet var sceneView: ARSCNView!
    private let navigationService = NavigationService()

    var destinationLocation: CLLocation!
    var locationService: LocationService!

    private var nodes: [DirectionNode] = []

    private var updateNodes: Bool = false
    private var updatedLocations: [CLLocation] = []
    private var locationUpdates: Int = 0 {
        didSet {
            if locationUpdates >= 4 {
                updateNodes = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        mapView.showsUserLocation = true
        mapView.delegate = self

        locationService.delegate = self
        setupMapView()
    }

    private func setupMapView() {
        guard let startingLocation = locationService.currentLocation else {
            return
        }

        let viewRegion = MKCoordinateRegion(center: startingLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(viewRegion, animated: false)

    }
    private func setupDirections() {
        navigationService
            .directions(to: destinationLocation) { [weak self] routes in
                self?.setupDirections(with: routes)
        }
    }

    private func setupDirections(with routes: [MKRoute]) {
        guard let startingLocation = locationService.currentLocation else {
            return
        }
        updateNodes = true

        let steps: [MKRoute.Step] = routes.reduce(into: []) { steps, route in
            steps.append(contentsOf: route.steps)
        }

        let stepCoordinates: [CLLocationCoordinate2D] = steps.map { $0.coordinate }

        let stepLocations: [CLLocation] = routes.reduce(into: []) { result, route in
            let locations = route.polyline.coordinates.map { $0.location }
            result.append(contentsOf: locations )
        }

        let intermediaryLocations =
            zip([startingLocation] + stepLocations, stepLocations)
                .map { current, destination in
                    current.intermediaryLocations(to: destination)
                }
                .flatMap { $0 }
                .filter { !stepCoordinates.contains($0.coordinate) }

        addAnnotation(steps: steps, locations: intermediaryLocations)
        addAnchors(steps: steps, locations: intermediaryLocations)
        updateNodePosition()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateNodes = true
        if updatedLocations.count > 0 && nodes.isEmpty {
            setupDirections()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private func updateNodePosition() {
        guard updateNodes && !updatedLocations.isEmpty else {
            return
        }

        locationUpdates += 1
        let startingLocation = CLLocation.bestLocationEstimate(locations: updatedLocations)
        nodes.forEach { node in
            let translation = matrix_identity_float4x4.transformMatrix(
                origin: startingLocation,
                destination: node.location)
            node.position = translation.position
        }
    }
}

extension ViewController: LocationServiceDelegate {
    func locationService(_ service: LocationService, didUpdateLocation location: CLLocation) {
        if location.horizontalAccuracy <= 65.0 {
            updatedLocations.append(location)
            updateNodePosition()
        }
    }

    func locationService(_ service: LocationService, didFailWithError error: Error) {
        print("Error getting current location: \(error)")
    }
}

extension ViewController {
    private func addAnnotation(steps: [MKRoute.Step], locations: [CLLocation]) {
        steps.forEach {
            mapView.addOverlay(StepOverlay(center: $0.coordinate, radius: 1))
        }

        locations.forEach {
            mapView.addOverlay(LocationOverlay(center: $0.coordinate, radius: 0.2))
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKCircle else {
            return MKOverlayRenderer()
        }

        let renderer = MKCircleRenderer(overlay: overlay)

        switch overlay {
        case is StepOverlay :
            renderer.fillColor = .red
            renderer.strokeColor = .red
        default:
            renderer.fillColor = .blue
            renderer.strokeColor = .blue
        }

        renderer.lineWidth = 2
        return renderer
    }
}

private extension ViewController {
    func addAnchors(steps: [MKRoute.Step], locations: [CLLocation]) {
        steps.forEach { addSphere(for: $0) }
        locations.forEach { addSphere(for: $0) }
    }

    func addSphere(for step: MKRoute.Step) {
        let location = step.location

        let sphere = DirectionNode(location: location,
                                   radius: 0.3,
                                   color: .red,
                                   title: step.instructions)
        sceneView.scene.rootNode.addChildNode(sphere)
        nodes.append(sphere)
    }

    func addSphere(for location: CLLocation) {
        let sphere = DirectionNode(location: location,
                                   radius: 0.2,
                                   color: .blue)
        sceneView.scene.rootNode.addChildNode(sphere)
        nodes.append(sphere)
    }
}

extension MKRoute.Step {
    var location: CLLocation {
        return CLLocation(latitude: polyline.coordinate.latitude,
                          longitude: polyline.coordinate.longitude)
    }

    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
}
