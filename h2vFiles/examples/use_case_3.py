import os, sys, itertools
sys.path.append(os.path.dirname(sys.path[0]))
from hw2vec.config import Config
from hw2vec.hw2graph import *


cfg = Config(sys.argv[1:])

''' prepare graph data '''
if not cfg.data_pkl_path.exists():
    #print("hitting the if statement\n")
    ''' converting graph using hw2graph '''
    nx_graphs = []
    hw2graph = HW2GRAPH(cfg)
    for hw_project_path in hw2graph.find_hw_project_folders():
        hw_graph = hw2graph.code2graph(hw_project_path)
        nx_graphs.append(hw_graph)
    
    data_proc = DataProcessor(cfg)
    for hw_graph in nx_graphs:
        data_proc.process(hw_graph)
        """ print(hw_graph)
        print(data_proc.num_node_labels) """
    data_proc.cache_graph_data(cfg.data_pkl_path)
    
else:
    ''' reading graph data from cache '''
    data_proc = DataProcessor(cfg)
    data_proc.read_graph_data_from_cache(cfg.data_pkl_path)

#print("Graphs: " + str(data_proc.get_graphs()))
#print("Num Node Labels: " + str(data_proc.num_node_labels))
#print(f"cfg hidden: %s", str(cfg.hidden))
''' prepare dataset '''
SIMILAR = 1
DISSIMILAR = -1

data_proc.generate_pairs()
all_pairs = data_proc.get_pairs()
for pair_idx, pair in enumerate(all_pairs):
    graph_a, graph_b = pair
    if graph_a.hw_type == graph_b.hw_type:
        all_pairs[pair_idx] += (SIMILAR,)
    else:
        all_pairs[pair_idx] += (DISSIMILAR,)

train_pairs, test_pairs = data_proc.split_dataset(cfg.ratio, cfg.seed, all_pairs)
#print(train_pairs)
#print(test_pairs)
train_loader = DataLoader(train_pairs, shuffle=True, batch_size=cfg.batch_size)
test_loader  = DataLoader(test_pairs, shuffle=True, batch_size=cfg.batch_size)

'''model configuration'''
model = GRAPH2VEC(cfg)
if cfg.model_path != "":
    model_path = Path(cfg.model_path)
    if model_path.exists():
        model.load_model(str(model_path/"model.cfg"), str(model_path/"model.pth"))
else:
    convs = [
        GRAPH_CONV("gcn", data_proc.num_node_labels, cfg.hidden),
        GRAPH_CONV("gcn", cfg.hidden, cfg.hidden)
    ]
    model.set_graph_conv(convs)

    pool = GRAPH_POOL("sagpool", cfg.hidden, cfg.poolratio)
    model.set_graph_pool(pool)

    readout = GRAPH_READOUT("max")
    model.set_graph_readout(readout)

    output = nn.Linear(cfg.hidden, cfg.embed_dim)
    model.set_output_layer(output)

''' training '''
model.to(cfg.device)
trainer = PairwiseGraphTrainer(cfg)
trainer.build(model)
trainer.train(train_loader, test_loader)

''' evaluating and inspecting '''
trainer.evaluate(cfg.epochs, train_loader, test_loader)
vis_loader = DataLoader(data_proc.get_graphs(), shuffle=False, batch_size=1)
trainer.visualize_embeddings(vis_loader, "./")