function display_pz(transfer_func)

transfer_func = zpk(transfer_func);
zeros = transfer_func.z{1,1};
poles = transfer_func.p{1,1};

zeros = sprintf('%f ',zeros);
poles = sprintf('%f ',poles);

zeros
poles