//
//  ImageSliderAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import UIKit
import Reusable

protocol ImageSliderAssembler {
    func resolve(navigationController: UINavigationController, images: String, position: Int) -> ImageSliderViewController
    func resolve(navigationController: UINavigationController, images: String, position: Int) -> ImageSliderViewModel
    func resolve(navigationController: UINavigationController) -> ImageSliderNavigatorType
    func resolve() -> ImageSliderUseCaseType
}

extension ImageSliderAssembler {
    func resolve(navigationController: UINavigationController, images: String, position: Int) -> ImageSliderViewController {
        let vc = ImageSliderViewController.instantiate()
        let vm: ImageSliderViewModel = resolve(navigationController: navigationController, images: images, position: position)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, images: String, position: Int) -> ImageSliderViewModel {
        return ImageSliderViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            images: images,
            position: position
        )
    }
}

extension ImageSliderAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> ImageSliderNavigatorType {
        return ImageSliderNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> ImageSliderUseCaseType {
        return ImageSliderUseCase()
    }
}
