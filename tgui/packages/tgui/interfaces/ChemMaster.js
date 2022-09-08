import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Dropdown, Stack, Icon, LabeledList, Section, Input } from "../components";
import { Window } from "../layouts";
import { BeakerContents } from './common/BeakerContents';

const transferAmounts = [1, 5, 10, 30, 60];

export const ChemMaster = (props, context) => {
  const { data } = useBackend(context);
  const {
    condi,
    beaker,
    beaker_reagents = [],
    buffer_reagents = [],
    mode,
  } = data;
  return (
    <Window
      width={575}
      height={550}
      resizable>
      <Window.Content scrollable className="Layout__content--flexColumn">
        <ChemMasterBeaker
          beaker={beaker}
          beakerReagents={beaker_reagents}
          bufferNonEmpty={buffer_reagents.length > 0}
        />
        <ChemMasterBuffer
          beaker={beaker}
          mode={mode}
          bufferReagents={buffer_reagents}
        />
        <ChemMasterProduction
          beaker={beaker}
          isCondiment={condi}
          bufferNonEmpty={buffer_reagents.length > 0}
        />
        {<ChemMasterCustomization />}
      </Window.Content>
    </Window>
  );
};

const ChemMasterBeaker = (props, context) => {
  const { act } = useBackend(context);
  const {
    beaker,
    beakerReagents,
    bufferNonEmpty,
  } = props;

  let headerButton = bufferNonEmpty ? (
    <Button.Confirm
      icon="eject"
      disabled={!beaker}
      content="Eject and Clear Buffer"
      onClick={() => act('eject')}
    />
  ) : (
    <Button
      icon="eject"
      disabled={!beaker}
      content="Eject and Clear Buffer"
      onClick={() => act('eject')}
    />
  );

  return (
    <Section
      title="Beaker"
      buttons={headerButton}>
      {beaker
        ? (
          <BeakerContents
            beakerLoaded
            beakerContents={beakerReagents}
            buttons={(chemical, i) => (
              <Box mb={(i < beakerReagents.length - 1) && "2px"}>
                <Button
                  content="Analyze"
                  mb="0"
                  onClick={() => act('analyze', {
                    idx: i + 1,
                    beaker: 1,
                  })}
                />
                {transferAmounts.map((am, j) =>
                  (<Button
                    key={j}
                    content={am}
                    mb="0"
                    onClick={() => act('add', {
                      id: chemical.id,
                      amount: am,
                    })}
                  />)
                )}
                <Button
                  content="All"
                  mb="0"
                  onClick={() => act('add', {
                    id: chemical.id,
                    amount: chemical.volume,
                  })}
                />
                <Button
                  content="Custom"
                  mb="0"
                  onClick={() => act('addcustom', {
                    idx: i + 1,
                    beaker: 1,
                  })}
                />
              </Box>
            )}
          />
        )
        : (
          <Box color="label">
            No beaker loaded.
          </Box>
        )}
    </Section>
  );
};

const ChemMasterBuffer = (props, context) => {
  const { act } = useBackend(context);
  const {
    beaker,
    mode,
    bufferReagents = [],
  } = props;
  return (
    <Section
      title="Buffer"
      flexGrow="1"
      buttons={
        <Box color="label">
          Transferring to&nbsp;
          <Button
            icon={mode ? "flask" : "trash"}
            color={!mode && "bad"}
            content={mode ? "Beaker" : "Disposal"}
            onClick={() => act('toggle')}
          />
        </Box>
      }>
      {bufferReagents && beaker
        ? (
          <BeakerContents
            beakerLoaded
            buffer
            beakerContents={bufferReagents}
            buttons={(chemical, i) => (
              <Box mb={(i < bufferReagents.length - 1) && "2px"}>
                <Button
                  content="Analyze"
                  mb="0"
                  onClick={() => act('analyze', {
                    idx: i + 1,
                    beaker: 0,
                  })}
                />
                {transferAmounts.map((am, i) =>
                  (<Button
                    key={i}
                    content={am}
                    mb="0"
                    onClick={() => act('remove', {
                      id: chemical.id,
                      amount: am,
                    })}
                  />)
                )}
                <Button
                  content="All"
                  mb="0"
                  onClick={() => act('remove', {
                    id: chemical.id,
                    amount: chemical.volume,
                  })}
                />
                <Button
                  content="Custom.."
                  mb="0"
                  onClick={() => act('removecustom', {
                    idx: i + 1,
                  })}
                />
              </Box>
            )}
          />
        )
        : (
          <Box color="label">
            Buffer is empty.
          </Box>
        )}
    </Section>
  );
};

const ChemMasterProduction = (props, context) => {
  if (!props.bufferNonEmpty || !props.beaker) {
    return (
      <Section
        title="Production">
        <Stack height="100%">
          <Stack.Item
            grow
            align="center"
            textAlign="center"
            color="label">
            <Icon
              name="tint-slash"
              mt="0.5rem"
              mb="0.5rem"
              size="5"
            /><br />
            Buffer is empty.
          </Stack.Item>
        </Stack>
      </Section>
    );
  }

  return (
    <Section
      title="Production">
      {!props.isCondiment ? (
        <ChemMasterProductionChemical />
      ) : (
        <ChemMasterProductionCondiment />
      )}
    </Section>
  );
};

const ChemMasterProductionChemical = (props, context) => {
  const { data, act } = useBackend(context);
  return (
    <LabeledList>
      <LabeledList.Item label="Pills">
        <Button
          icon="circle"
          content="One (60u max)"
          mr="0.5rem"
          onClick={() => act('create_pill')}
        />
        <Button
          icon="plus-circle"
          content="Multiple"
          mb="0.5rem"
          onClick={() => act('create_pill_multiple')}
        /><br />
        <Stack>
          <Stack.Item>
            <Button
              icon="chevron-left"
              iconSize={3.1}
              onClick={() => act('change_pill_style', { "new_pill_style": data.pillsprite <= 1 ? 25 : data.pillsprite-1 })}
            />
          </Stack.Item>
          <Stack.Item>
            <Button>
              <Box
                as="img" style={{ "transform": "scale(1.5);", "-ms-interpolation-mode": "nearest-neighbor;" }}
                src={"pill"+data.pillsprite+".png"} />
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="chevron-right"
              iconSize={3.1}
              onClick={() => act('change_pill_style', { "new_pill_style": data.pillsprite >= 25 ? 1 : data.pillsprite+1 })}
            />
          </Stack.Item>
        </Stack>
      </LabeledList.Item>
      <LabeledList.Item label="Bottle">
        <Button
          icon="wine-bottle"
          content="Create bottle (60u max)"
          mr="0.5rem"
          mb="0.5rem"
          onClick={() => act('create_bottle')}
        />
        <Button
          icon="plus-square"
          content="Multiple"
          onClick={() => act('create_bottle_multiple')}
        /><br />
        <Stack>
          <Stack.Item>
            <Button
              icon="chevron-left"
              iconSize={3.1}
              onClick={() => act('change_bottle_style', { "new_bottle_style": data.bottlesprite <= 1 ? 4 : data.bottlesprite-1 })}
            />
          </Stack.Item>
          <Stack.Item>
            <Button>
              <Box
                as="img" style={{ "transform": "scale(1.5);", "-ms-interpolation-mode": "nearest-neighbor;" }}
                src={"bottle-"+data.bottlesprite+".png"} />
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="chevron-right"
              iconSize={3.1}
              onClick={() => act('change_bottle_style', { "new_bottle_style": data.bottlesprite >= 4 ? 1 : data.bottlesprite+1 })}
            />
          </Stack.Item>
        </Stack>
      </LabeledList.Item>
    </LabeledList>
  );
};

const ChemMasterProductionCondiment = (props, context) => {
  const { act } = useBackend(context);
  return (
    <Fragment>
      <Button
        icon="box"
        content="Create condiment pack (10u max)"
        mb="0.5rem"
        onClick={() => act('create_condi_pack')}
      /><br />
      <Button
        icon="wine-bottle"
        content="Create bottle (60u max)"
        mb="0"
        onClick={() => act('create_condi_bottle')}
      />
    </Fragment>
  );
};

const ChemMasterCustomization = (props, context) => {
  const { act, data } = useBackend(context);
  if (!data.loaded_pill_bottle) {
    return (
      <Section title="Pill Bottle Customization">
        <Box color="label">
          None loaded.
        </Box>
      </Section>
    );
  }

  return (
    <Section title="Pill Bottle Customization" buttons={
      <Button
        disabled={!data.loaded_pill_bottle}
        icon="eject"
        content={data.loaded_pill_bottle
          ? (
            data.loaded_pill_bottle_name
              + " ("
              + data.loaded_pill_bottle_contents_len
              + "/"
              + data.loaded_pill_bottle_storage_slots
              + ")"
          )
          : "None loaded"}
        mb="0.5rem"
        onClick={() => act('ejectp')}
      />
    }>
      <Stack>
        <Stack.Item>
          <Dropdown
            nochevron
            over
            noscroll
            textAlign="center"
            options={data.pill_bottle_colors}
            selected={data.loaded_pill_bottle_color}
            mb="0.5rem"
            onSelected={(value) => act('change_pill_bottle_style', { color: value })} />
          <div class={"pill_bottles96x96 "+data.loaded_pill_bottle_color+"_pill_bottle"} />
        </Stack.Item>
        <Stack.Item>
          <Box fontSize={2}>
            pill bottle (<Input
              maxLength={20}
              value={data.loaded_pill_bottle_second_name}
              onInput={(e, value) => act("change_pill_bottle_name", { name: value })} />)
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
