// ANCHOR: app
use crux_core::render::Render;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum BridgeEchoEvent {
    Tick,
    NewPeriod,
}

#[derive(Default, Debug, PartialEq)]
pub struct BridgeEchoModel {
    log: Vec<usize>,
    count: usize,
}

#[derive(Serialize, Deserialize, Clone, PartialEq, Debug)]
pub struct BridgeViewModel {
    pub count: usize,
}

#[cfg_attr(feature = "typegen", derive(crux_core::macros::Export))]
#[derive(crux_core::macros::Effect)]
#[effect(app = "BridgeEcho")]
pub struct BridgeEchoCapabilities {
    render: Render<BridgeEchoEvent>,
}

pub type BridgeEchoEffect = Effect;

#[derive(Default)]
pub struct BridgeEcho;

// ANCHOR: impl_app
impl crux_core::App for BridgeEcho {
    type Event = BridgeEchoEvent;
    type Model = BridgeEchoModel;
    type ViewModel = BridgeViewModel;
    type Capabilities = BridgeEchoCapabilities;

    fn update(&self, event: Self::Event, model: &mut Self::Model, caps: &Self::Capabilities) {
        match event {
            BridgeEchoEvent::Tick => model.count += 1,
            BridgeEchoEvent::NewPeriod => {
                model.log.push(model.count);
                model.count = 0;
            }
        };

        caps.render.render();
    }

    fn view(&self, model: &Self::Model) -> Self::ViewModel {
        BridgeViewModel { count: model.count }
    }
}
// ANCHOR_END: impl_app
// ANCHOR_END: app

// ANCHOR: test
#[cfg(test)]
mod test {
    use super::*;
    use crux_core::{assert_effect, testing::AppTester};

    #[test]
    fn shows_initial_count() {
        let app = AppTester::<BridgeEcho, _>::default();
        let model = BridgeEchoModel::default();

        let actual_view = app.view(&model);
        let expected_view = BridgeViewModel { count: 0 };

        assert_eq!(actual_view, expected_view);
    }

    #[test]
    fn increments_count() {
        let app = AppTester::<BridgeEcho, _>::default();
        let mut model = BridgeEchoModel::default();

        app.update(BridgeEchoEvent::Tick, &mut model);
        app.update(BridgeEchoEvent::Tick, &mut model);
        app.update(BridgeEchoEvent::Tick, &mut model);

        let actual_view = app.view(&model);
        let expected_view = BridgeViewModel { count: 3 };

        assert_eq!(actual_view, expected_view);
    }

    #[test]
    fn logs_previous_counts() {
        let app = AppTester::<BridgeEcho, _>::default();
        let mut model = BridgeEchoModel::default();

        app.update(BridgeEchoEvent::Tick, &mut model);
        app.update(BridgeEchoEvent::Tick, &mut model);
        app.update(BridgeEchoEvent::Tick, &mut model);
        app.update(BridgeEchoEvent::NewPeriod, &mut model);
        app.update(BridgeEchoEvent::Tick, &mut model);
        app.update(BridgeEchoEvent::Tick, &mut model);
        app.update(BridgeEchoEvent::NewPeriod, &mut model);
        app.update(BridgeEchoEvent::Tick, &mut model);

        let expected = BridgeEchoModel {
            log: vec![3, 2],
            count: 1,
        };
        assert_eq!(model, expected);
    }

    #[test]
    fn renders_on_tick() {
        let app = AppTester::<BridgeEcho, _>::default();
        let mut model = BridgeEchoModel::default();

        let update = app.update(BridgeEchoEvent::Tick, &mut model);

        assert_effect!(update, Effect::Render(_));
    }

    #[test]
    fn renders_on_new_period() {
        let app = AppTester::<BridgeEcho, _>::default();
        let mut model = BridgeEchoModel::default();

        let update = app.update(BridgeEchoEvent::NewPeriod, &mut model);

        assert_effect!(update, Effect::Render(_));
    }
}
// ANCHOR_END: test
